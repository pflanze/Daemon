
=head1 NAME

Chj_library

=head1 SYNOPSIS

=head1 DESCRIPTION

Library for Daemon package, mostly put together from Chj:: modules.

=cut

# for simplicity, just use the main namespace to avoid having to export stuff.
#package Chj_library;
#@ISA="Exporter"; require Exporter;
#@EXPORT=qw();
#@EXPORT_OK=qw();
#%EXPORT_TAGS=(all=>[@EXPORT,@EXPORT_OK]);

use strict;

sub msg {
    print @_,"\n"
}

sub xenv {
    my ($key)=@_;
    my $v= $ENV{$key};
    defined $v
      or die "missing environment variable '$key'";
    $v
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

use Carp;

sub xsystem {
    @_>0 or croak "xsystem: missing arguments";
    no warnings;
    (system @_)>=0
      or croak "xsystem: could not start command '$_[0]': $!";
    $?
}


sub xpipe {
    if (@_) {
	confess "form with arguments not yet supported";
    } else {
	pipe my $r,my $w or croak "xpipe: $!";
	($r,$w)
    }
}


1
