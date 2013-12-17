#!/usr/bin/perl
use strict;

sub read3lines {
	my ($fh) = @_;
	my @l;
	my $maxlen = 0;
	for my $i (0..2) {
		my $l1 = <$fh>;
		chomp($l1);
		my $len = length($l1);
		$maxlen = $len if ($len > $maxlen);
		push @l, $l1;
	}
	for my $i (0..2) {
		my $len = length($l[$i]);
		my $missing = $maxlen - $len;
		if ($missing > 0) {
			$l[$i] .= " " x $missing;
		}
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
	return "?";
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
	my $ok = "";
	if ($num =~ /\?/) {
		$ok = "UNKNOWN";
	} else {
		$ok = (! check_sum($num) ? "OK" : "ERROR");
	}
	print "$num: $ok\n";
}

