#! /usr/bin/perl

#
#	くずはすくりぷと Rev.0.1 Preview 9 (2000.9.3)
#	 (書き込み検索用関数群)
#

###############################################################################
#  検索・結果表示
###############################################################################

sub srcmessage {
	
	my $success = 0;
	
	&loadmessage;
	&prterror ( 'There are no parameters. ' ) if ( !$FORM{'s'} );
	
	&prthtmlhead ( "$bbstitle Post Search" );
	print "<HR>\n";
	foreach ( 0 .. @logdata - 1 ) {
		&getmessage ( $logdata[$_] );
		if ( $FORM{'m'} eq 's' ) {
			if ( $FORM{'s'} eq $user ) {
				$success++;
				print &prtmessage ( 3, '' );
			}
		} elsif ( $FORM{'m'} eq 't' ) {
			if ( $FORM{'s'} eq $thread || $FORM{'s'} eq $postid ) {
				$success++;
				if ( $FORM{'ff'} ) {
					print &prtmessage ( 1, $FORM{'ff'} );
				} else {
					print &prtmessage ( 0, '' );
				}
			}
		}
		$i++;
	}
	
	if ( !$success ) {
		print "<H3>The specified message cannot be found. </H3></BODY></HTML>";
		exit;
	}
	
	print "</BODY></HTML>";
	exit;
}

1;


__END__
