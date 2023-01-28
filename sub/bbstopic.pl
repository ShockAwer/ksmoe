#! /usr/bin/perl

#
#	くずはすくりぷと Rev.0.1 Preview 9 (2000.9.3)
#	 (トピック一覧表示)
#

my ( @TID, %TCOUNT, %TTITLE, %TTIME );

###############################################################################
#  トピック一覧取得
###############################################################################

sub gettopic {
	
	my ( @olglog );
	
	if ( $FORM{'e'} =~ /^[\w.]+$/ ) {

		$FORM{'e'} =~ /.*\.(.*)/;
		if ( $1 =~ /htm/ || !$oldlogfmt ) {
			
			# HTML形式
			# (HTML形式の場合、スレッドIDの取得ができないので、本スクリプトでは
			#  サポートされません)
			&prterror ( 'HTML-formatted logs are not supported.' );
			
		} else {
			
			# バイナリ形式
			open ( OLDLOG, "$oldlogfiledir$FORM{'e'}" ) || &prterror ( "$FORM{'e'} could not be opened." );
			eval 'flock ( OLDLOG, 1 )';
			seek ( OLDLOG, 0, 0 );
			@oldlog = <OLDLOG>;
			eval 'flock ( OLDLOG, 8 )';
			close ( OLDLOG );
			
			$j = 0;
			for ( $i = 0 ; $i < @oldlog ; $i++ ) {
				&getmessage ( $oldlog[$i] );
				if ( !$thread || ( $thread && !$TTITLE{$thread} ) ) {
					$TID[$j] = $postid;
					$TCOUNT{$postid} = 0;
					$TTITLE{$postid} = $msg;
					$TTITLE{$postid} =~ s/\r(.*)//g;
					$TTITLE{$postid} =~ s/\r//g;
					$TTIME{$postid} = $ndate;
					$j++;
				} else {
					$TCOUNT{$thread}++;
					$TTIME{$thread} = $ndate;
				}
			}
		}
		
	} else {
		&prterror ( 'File name is unknown.' );
	}
}


###############################################################################
#  トピック一覧表示
###############################################################################

sub lsttopic {
	
	my ( $tc, $tt );
	
	&gettopic;
	
	$FORM{'e'} =~ /(\d\d\d\d)(\d\d)(\d\d)\.(\w)/;
	&prthtmlhead ( "$bbstitle Topic List $1/$2/$3" );
	
	print <<EOF;
<P><STRONG><FONT size="+1">$bbstitle Topic List</FONT></STRONG></P>
<FONT size="-1">Table - Number of pieces - Content - Last updated on</FONT>
<HR>
<FONT size="-1">
EOF
	
	for ( $i = 0 ; $i < @TID ; $i++ ) {
		$tc = sprintf ( "%02d", $TCOUNT{$TID[$i]} );
		$tt = &getnowdate ( $TTIME{$TID[$i]} );
		print <<EOF;
<A href="$cgiurl?m=t&ff=$FORM{'e'}&s=$TID[$i]&c=$FORM{'c'}">◆</A> $tc $TTITLE{$TID[$i]} ($tt)<BR>
EOF
	}
	
	print <<EOF;
</FONT>
<HR>
<P align="right"><A href="$cgiurl">Go to Bulletin Board</A></P>
</BODY>
</HTML>
EOF
	exit;
}

1;
