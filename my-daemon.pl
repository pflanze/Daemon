#!/usr/bin/perl -w

use strict;

our $servicename="my-daemon";
our $pidfile="/var/run/$servicename.pid";
our $lockfile="/var/run/$servicename.lck";
our $daemon="/opt/my-daemon/daemon";  # change to the full path to the daemon script

use Fcntl ':flock';
use POSIX qw(setsid);

sub msg {
    print @_,"\n"
}

sub try_lock {
    # set up to get the close-on-exec flag cleared for the lockfh
    local $^F= 9999;
    # filehandle we will flock
    open my $lockfh, ">", $lockfile
      or die $!;
    if (flock $lockfh, LOCK_EX|LOCK_NB) {
	$lockfh
    } else {
	undef
    }
}

sub xfork {
    my $pid=fork;
    defined $pid or die "fork: $!";
    $pid
}

sub xexec {
    exec @_
      or exit 127;
}

sub xclose {
    my ($fh)=@_;
    close $fh
      or die "close $fh: $!";
}

sub xdup2 {
    my $self=shift;
    my $myfileno= CORE::fileno $self;
    defined $myfileno
      or die;
    require POSIX;
    for my $dup (@_) {
	my $fileno= $dup=~ /^\d+\z/s ? $dup : die;
	POSIX::dup2($myfileno,$fileno)
	  or die "xdup2 (fd $myfileno) to $dup (fd $fileno): $!";
    }
}


sub start {
    if (my $lockfh= try_lock) {
	if (my $pid = xfork) {
	    open my $pidfh, ">", $pidfile
	      or die $!;
	    print $pidfh $pid
	      or die $!;
	    xclose $pidfh;
	} else {
	    # child
	    setsid
	      or die $!;
	    # chdir "/";
	    # set up loggging and run daemon:
	    pipe my $r, my $w
	      or die $!;
	    if (xfork) {
		xclose $r;
		xdup2 $w, 1;
		xdup2 $w, 2;
		xclose $w;
		xexec $daemon;
	    } else {
		xclose $w;
		xdup2 $r, 0;
		xclose $r;
		xexec "logger", "-t", $servicename
	    }
	}
    } else {
	msg "already running."
    }
}

sub stop {
    if (my $lockfh= try_lock) {
	msg "not running.";
    } else {
	open my $pidfh, "<", $pidfile
	  or die $!;
	my $pid= <$pidfh>;
	xclose $pidfh;
	# kill the process group:
	kill -2, $pid
	  or warn "could not kill $pid: $!";
    }
}

sub usage {
    msg "usage: $0 start|stop|restart";
    exit 1;
}

my ($cmd)= @ARGV;
$cmd or usage;

my $cmds=
  +{
    stop=> \&stop,
    start=> \&start,
    restart=> sub {
	stop;
	start;
    },
   };

my $c= $$cmds{$cmd}
  or usage;
&$c;
