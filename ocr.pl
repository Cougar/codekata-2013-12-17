#!/usr/bin/perl
use strict;

sub read3lines {
	my ($fh) = @_;
	my @l;
	for my $i (0..2) {
		my $l1 = <$fh>;
		push @l, $l1;
	}
	my $tmp = <$fh>;
	return @l;
}

sub splitchars {
	my @l= @_;
	my @ch = ();
	while ($l[0] ne "") {
		my $c = "";
		for my $i (0..2) {
			if ($l[$i] =~ /^(...)(.*)$/) {
				$c .= $1;
				$l[$i] = $2;
			} else {
				die "ERROR";
			}
		}
		push @ch, $c;
	}
	return @ch;
}

sub sslookup {
	my ($ch) = @_;

	my @tbl = (
		' _ | ||_|',
		'     |  |',
		' _  _||_ ',
		' _  _| _|',
		'   |_|  |',
		' _ |_  _|',
		' _ |_ |_|',
		' _   |  |',
		' _ |_||_|',
		' _ |_| _|'
	);
	for my $k (0 .. $#tbl) {
		return $k if ($ch eq $tbl[$k]);
	}
	die "UNKNOWN NUMBER: [$ch]";
}

sub getline {
	my ($fh) = @_;
	my $l = "";
	my @ch = splitchars(read3lines($fh));
	for my $c (@ch) {
		$l .= sslookup($c);
	}
	return $l;
}

sub check_sum {
	my ($num) = @_;
	my $sum = 0;
	for my $k (1 .. 9) {
		$sum += $k * substr($num, -1 * $k, 1);
	}
	return $sum % 11;
}

open my $fh, '<&STDIN';
while (! eof) {
	my $num = getline($fh);
	my $ok = check_sum($num);
	print "$num: " . (! $ok ? "OK" : "ERROR") . "\n";
}

