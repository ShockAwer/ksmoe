#! /usr/bin/perl

#
#	くずはすくりぷと Rev.0.1 Preview 9 (2000.9.3)
#	 (管理ツール)
#

###############################################################################
#  メッセージ削除モードメイン画面表示
###############################################################################

sub msglist {
	
	my @msgline;
	
	&prthtmlhead ( 'KuzuhaScript Message Delete Mode' );
	print <<EOF;
<CENTER>
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="u" value="$FORM{'u'}">
<INPUT type="hidden" name="ad" value="kx">
<H3 align="center">KuzuhaScript Message Delete Mode</H3>
<TABLE border="1">
  <TR>
   <TH nowrap>Delete</TH>
    <TH nowrap>Posted date</TH>
    <TH nowrap>Title</TH>
    <TH nowrap>Author</TH>
    <TH nowrap>Details (partial)</TH>
  </TR>
EOF
	
	&loadmessage;
	for ( $i = 0 ; $i < @logdata ; $i++ ) {
		&getmessage ( $logdata[$i] );
		@msgline = split ( /\r/, $msg );
		$msg = $msgline[0];
		print <<EOF;
  <TR>
    <TD align="center" nowrap><INPUT type="checkbox" name="id$postid" value="checked"></TD>
    <TD nowrap>$wdate</TD>
    <TD nowrap>$title 　</TD>
    <TD nowrap>$user</TD>
    <TD nowrap>$msg</TD>
  </TR>
EOF
	}
	
	print <<EOF;
</TABLE>
<INPUT type="submit" value="Deletion Execution">
</FORM>
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="u" value="$FORM{'u'}">
<INPUT type="hidden" name="ad" value="tp">
<INPUT type="submit" value="Terminate">
</FORM>
</CENTER>
</BODY>
</HTML>
EOF
}


###############################################################################
#  メッセージ削除
###############################################################################

sub msgdel {
	
	my ( @newlog, @newoldlog, $logitems, $oldlogitems );
	
	open ( FLOG, "+<$logfilename" ) || &prterror ( 'Message loading failed.' );
	eval 'flock ( FLOG, 2 )';
	seek ( FLOG, 0, 0 );
	@logdata = <FLOG>;
	
	for ( $i = 0 ; $i < $logsave ; $i++ ) {
		@logitems = split ( /\,/, $logdata[$i] );
		if ( $FORM{"id$logitems[1]"} eq 'checked' ) {
			
			if ( $oldlogfiledir && $oldlogfmt ) {
				&getnowdate ( $logitems[0] );
				if ( !$oldlogsavesw ) {
					$oldlogfilename = sprintf ( "%s/%d%02d%02d.dat",
					  $oldlogfiledir, $year, $mon, $mday );
				} else {
					$oldlogfilename = sprintf ( "%s%d%02d.dat",
					  $oldlogfiledir, $year, $mon );
				}
				open ( CLOG, "+<$oldlogfilename" ) || &prterror ( 'Failed to load logs.' );
				eval 'flock ( CLOG, 2 )';
				seek ( CLOG, 0, 0 );
				@oldlogdata = <CLOG>;
				
				undef @newoldlog;
				for ( $j = 0 ; $j < $logsave ; $j++ ) {
					@oldlogitems = split ( /\,/, $oldlogdata[$j] );
					if ( $logitems[1] ne $oldlogitems[1] ) {
						$newoldlog[$j] = $oldlogdata[$j];
					}
				}
				
				$oldstream = select ( CLOG );
				$| = 1;
				seek ( CLOG, 0, 0 );
				truncate ( CLOG, 0 );
				print CLOG @newoldlog;
				eval 'flock ( CLOG, 8 )';
				close ( CLOG );
				select ( $oldstream );
			}
			
		} else {
			$newlog[$i] = $logdata[$i];
		}
	}
	
	$oldstream = select ( FLOG );
	$| = 1;
	seek ( FLOG, 0, 0 );
	truncate ( FLOG, 0 );
	print FLOG @newlog;
	eval 'flock ( FLOG, 8 )';
	close ( FLOG );
	select ( $oldstream );
}


###############################################################################
#  パスワード設定画面表示
###############################################################################

sub setpass {
	
	&prthtmlhead ( 'KuzuhaScript Password Setting Screen' );
	print <<EOF;
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="ad" value="ps">
<H2 align="center">KuzuhaScript Password Setting Screen</H2>
<HR>
<CENTER>
<TABLE>
  <TR>
    <TD>
      <FONT size="+1">Password setting. </FONT><BR>
      Please enter the "Admin Password" that will be used from now on to manage the bulletin board. 
    </TD>
  </TR>
</TABLE>
<BR>
<TABLE border="2" cellspacing="4">
  <TR>
    <TD>The admin password will be:</TD>
    <TD><INPUT size="30" type="text" name="ps" maxlength="127"></TD>
  </TR>
  <TR>
    <TD colspan="2"><FONT size="-1">
      The password you enter here will be used when posting under the administrator's name and authenticating in admin mode.<br>(Make sure it is easy to remember)
      </FONT>
    </TD>
  </TR>
</TABLE>
<BR>
<INPUT type="submit" value="I want to use this!">　<INPUT type="reset" value="Scrap that...">
</CENTER>
</FORM>
</BODY>
</HTML>
EOF
}


###############################################################################
#  暗号化テスト
###############################################################################

sub MD5test {
	
	my $tpass = 'ABCDE';
	my $tsalt = 'r7';
	my ( $cpass, $rpass, $slen );
	
	$MD5salt = '$1$';
	$cpass = crypt ( $tpass, "$MD5salt$tsalt" );
	if ( $cpass =~ /^\$1\$/ ) {
		$slen = 5;
	} else {
		$slen = 2;
	}
	$rpass = crypt ( $tpass, substr ( $cpass, 0, $slen ) );
	if ( ( $slen == 5 ) && ( $cpass eq $rpass ) && $cpass ) {
		return 2;
	} else {
		$cpass = crypt ( $tpass, "$tsalt" );
		$rpass = crypt ( $tpass, substr ( $cpass, 0, 2 ) );
		if ( ( $cpass eq $rpass ) && $cpass ) {
			return 1;
		} else {
			return 0;
		}
	}
}


###############################################################################
#  パスワード生成
###############################################################################

sub makepass {
	
	my $pass = $_[0];
	my ( $salt, $ctype, $cpass );
	my @saltlist = ( '0'..'9', 'A'..'Z', 'a'..'z' );
	
	if ( length ( $pass ) > 5 ) {
		$ctype = &MD5test;
		if ( $ctype > 0 ) {
			srand ( time ^ ( $$ + ( $$ << 15 ) ) );
			$salt = splice ( @saltlist, int ( rand ( @saltlist ) ), 1 ) . 
			  splice ( @saltlist, int ( rand ( @saltlist ) ), 1 );
			
			if ( $ctype == 2 ) {
				$cpass = crypt ( $pass, "\$1\$$salt" );
			} else {
				$cpass = crypt ( $pass, "$salt" );
			}
		} else {
			$cpass = $pass;
		}
		return $cpass;
	} else {
		&prterror ( 'Password is too short, please enter a string of at least 6 digits. ' );
	}
}


###############################################################################
#  パスワード表示
###############################################################################

sub prtpass {
	
	my $cpass = &makepass ( $FORM{'ps'} );
	&prthtmlhead ( 'Password' );
	print <<EOF;
<H2 align="center">KuzuhaScript Password Setting Screen</H2>
<HR>
<FORM>
<CENTER>
<TABLE>
  <TR>
    <TD>
      <FONT size="+1">Password generated and encyrpted. </FONT><BR>
      Copy the following encrypted password string into the designated location into the configuration of bbs.cgi -- between the singular quotes in line 218
    </TD>
  </TR>
</TABLE>
<BR>
<TABLE border="2" cellspacing="4">
  <TR>
    <TD>Admin password</TD>
    <TD><INPUT type="text" name="dummy" value="$cpass" readonly></TD>
  </TR>
</TABLE>
</FORM>
</BODY>
</HTML>
EOF
}


###############################################################################
#  ログ表示
###############################################################################

sub logprint {
	
	&loadmessage;
	print "Content-Type: text/plain\n\n";
	
	print @logdata;
}


###############################################################################
#  管理メニュー画面表示
###############################################################################

sub adminmenu {
	
	&prthtmlhead ( 'KuzuhaScript Management Menu' );
	print <<EOF;
<H2 align="center">KuzuhaScript Management Menu</H2>
<HR>
<CENTER>
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="ad" value="kl">
<INPUT type="hidden" name="u" value="$FORM{'u'}">
<INPUT type="submit" value="Message Deletion">
</FORM>
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="ad" value="rp">
<INPUT type="hidden" name="u" value="$FORM{'u'}">
<INPUT type="submit" value="Encrypted password regeneration">
</FORM>
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="ad" value="lv">
<INPUT type="hidden" name="u" value="$FORM{'u'}">
<INPUT type="submit" value="Log Viewing">
</FORM>
<FORM method="post" action="$cgiurl">
<INPUT type="submit" value="Terminate">
</FORM>
</CENTER>
</BODY>
</HTML>
EOF
}


###############################################################################
#  管理モードメイン処理
###############################################################################

sub adminmain {
	
	if ( !$FORM{'ad'} || $FORM{'ad'} eq 'tp' ) {
		&adminmenu;
	} elsif ( $FORM{'ad'} eq 'ps' ) {
		if ( $FORM{'ps'} ) {
			&prtpass;
		} else {
			&prterror ( 'Password not entered. ' );
		}
	} else {
		if ( &chkpasswd ) {
			if ( $FORM{'ad'} eq 'rp' ) {
				&setpass;
			} elsif ( $FORM{'ad'} eq 'kl' ) {
				&msglist;
			} elsif ( $FORM{'ad'} eq 'kx' ) {
				&msgdel;
				&msglist;
			} elsif ( $FORM{'ad'} eq 'lv' ) {
				&logprint;
			}
		} else {
			&prterror ( 'Authentication failed. ' );
		}
	}
}


1;
