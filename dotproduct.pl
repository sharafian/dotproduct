#!/usr/bin/perl
use strict;
use warnings;

use YAML::XS;
use File::slurp;
use File::Copy;

sub YAMLfromFile {
	my $file = shift;
	return Load( read_file($file)
		or die "could not open file")
		or die "could not parse file as YAML";
}

sub processFile {
	my $file = shift;
	my $dref = shift;
	my $vref = shift;

	my $text = read_file($file);

	my $delim = $dref->{delimeter} or $dref->{delim};
	if (defined $delim) {
		$text = replacePatterns($text, $vref, $delim);
	}	

	my $dest = $dref->{destination} or $dref->{dest}
		or die "could not find destination for $file";	
	copyToFile($text, $dest);
}

sub replacePatterns {
	my $text  = shift;
	my $vref  = shift;
	my $delim = shift;
}
sub copyToFile {
	my $text = shift;
	my $dest = shift;

	open FILE, '>', $dest
		or die "could not open $dest";
	print FILE $text;	
	close FILE;
}
sub runCommand {
	system $_[0];
}

my $data = YAMLfromFile($configfile);

foreach my $file (keys $data->{files}) {
	processFile($file, $data->{files}->{$file}, $data->{variables});	
}
foreach my $command ($data->{commands}) {
	runCommand($command);	
}

print "Complete!\n"
