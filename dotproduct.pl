#!/usr/bin/env perl
use strict;
use warnings;

use YAML::XS;
use File::Slurp;

sub usage {
	print "usage: dotproduct.pl <config.yml>\n";
}
sub getArgs {
	if (defined $ARGV[0]) {
		return $ARGV[0];
	} else {
		usage();
		exit;
	}	
}

sub YAMLfromFile {
	my $file = shift;
	my $yaml = YAML::XS::LoadFile($file)
		or die "could not parse file as YAML";
	return $yaml;
}
sub subdir {
	my ($dir, $sdir) = @_;

	if ($dir =~ /^(.+?)\/*$/) {
		return $1 . '/' . $sdir;
	}
	return;
}
sub superdir {
	return subdir($_[0], "..");
}
sub processEntry {
	my ($file, $dref, $vref) = @_;

	my $src = $dref->{source}
		or die "could not find source for $file";
	my $dest = $dref->{destination}
		or die "could not find destination for $file";	
	my $delim = $dref->{delimeter};

	if (-f $src) {
		processFile($src, $dest, $vref, $delim);
	} elsif (-d $src) {
		processFile($src, $dest, $vref, $delim);
	}
}
sub processFile {
	my ($src, $dest, $vref, $delim) = @_;

	if (-d $src) {
		opendir DIR, $src;
		while (readdir DIR) {
			if ($_ ne '.' && $_ ne '..') {
				processFile(subdir($src,$_), subdir($dest, $_), $vref, $delim);
			}
		}
		closedir DIR;
		return;
	}

	my $text = read_file($src);
	$text = replacePatterns($text, $vref, $delim) if defined $delim;

	copyToFile($text, $dest);
}

sub replacePatterns {
	my ($text, $vref, $delim) = @_;

	my $newtext = '';
	my $isvar = 0;
	foreach my $part (split /$delim/, $text) {

		if ($isvar && defined $vref->{$part}) {
			$newtext .= $vref->{$part};
		} else {
			$newtext .= $part;
		}
		$isvar = not $isvar;	
	}
	return $newtext;
}
sub copyToFile {
	my ($text, $dest) = @_;

	print "$dest\n";

	open FILE, '>', $dest
		or die "could not open $dest";
	print FILE $text;	
	close FILE;
}
sub runCommand {
#	system $_[0];
}

my $configfile = getArgs();
my $data = YAMLfromFile($configfile);

foreach my $file (keys %{$data->{files}}) {
	processEntry($file, $data->{files}->{$file}, $data->{variables});	
}
foreach my $command ($data->{commands}) {
	runCommand($command);	
}

print "Complete!\n"
