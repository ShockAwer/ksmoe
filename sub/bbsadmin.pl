#! /usr/local/bin/perl

#
#	�����͂�����Ղ� Rev.0.1 Preview 9 (2000.9.3)
#	 (�Ǘ��c�[��)
#

###############################################################################
#  ���b�Z�[�W�폜���[�h���C����ʕ\��
###############################################################################

sub msglist {
	
	my @msgline;
	
	&prthtmlhead ( '�����͂�����Ղ� ���b�Z�[�W�폜���[�h' );
	print <<EOF;
<CENTER>
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="u" value="$FORM{'u'}">
<INPUT type="hidden" name="ad" value="kx">
<H3 align="center">�����͂�����Ղ� ���b�Z�[�W�폜���[�h</H3>
<TABLE border="1">
  <TR>
    <TH nowrap>�폜</TH>
    <TH nowrap>���e��</TH>
    <TH nowrap>�薼</TH>
    <TH nowrap>���e��</TH>
    <TH nowrap>���e�i�ꕔ�j</TH>
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
    <TD nowrap>$title �@</TD>
    <TD nowrap>$user</TD>
    <TD nowrap>$msg</TD>
  </TR>
EOF
	}
	
	print <<EOF;
</TABLE>
<INPUT type="submit" value="�폜���s">
</FORM>
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="u" value="$FORM{'u'}">
<INPUT type="hidden" name="ad" value="tp">
<INPUT type="submit" value="�I��">
</FORM>
</CENTER>
</BODY>
</HTML>
EOF
}


###############################################################################
#  ���b�Z�[�W�폜
###############################################################################

sub msgdel {
	
	my ( @newlog, @newoldlog, $logitems, $oldlogitems );
	
	open ( FLOG, "+<$logfilename" ) || &prterror ( '���b�Z�[�W�ǂݍ��݂Ɏ��s���܂���' );
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
				open ( CLOG, "+<$oldlogfilename" ) || &prterror ( '�ߋ����O�ǂݍ��݂Ɏ��s���܂���' );
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
#  �p�X���[�h�ݒ��ʕ\��
###############################################################################

sub setpass {
	
	&prthtmlhead ( '�����͂�����Ղ� �p�X���[�h�ݒ���' );
	print <<EOF;
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="ad" value="ps">
<H2 align="center">�����͂�����Ղ� �p�X���[�h�ݒ���</H2>
<HR>
<CENTER>
<TABLE>
  <TR>
    <TD>
      <FONT size="+1">�p�X���[�h�ݒ���s���܂��B</FONT><BR>
      ���ꂩ��f���̊Ǘ��Ŏg�p����u�Ǘ��p�p�X���[�h�v����͂��Ă��������B
    </TD>
  </TR>
</TABLE>
<BR>
<TABLE border="2" cellspacing="4">
  <TR>
    <TD>�Ǘ��p�p�X���[�h</TD>
    <TD><INPUT size="30" type="text" name="ps" maxlength="127"></TD>
  </TR>
  <TR>
    <TD colspan="2"><FONT size="-1">
      �����œ��͂���p�X���[�h�́A�Ǘ��l���ł̓��e�A�Ǘ����[�h�̔F�؂̍ۂɎg�p���܂��B
      </FONT>
    </TD>
  </TR>
</TABLE>
<BR>
<INPUT type="submit" value="�ݒ�">�@<INPUT type="reset" value="���Z�b�g">
</CENTER>
</FORM>
</BODY>
</HTML>
EOF
}


###############################################################################
#  �Í����e�X�g
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
#  �p�X���[�h����
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
		&prterror ( '�p�X���[�h���Z�����܂��B�U���ȏ�̕��������͂��Ă��������B' );
	}
}


###############################################################################
#  �p�X���[�h�\��
###############################################################################

sub prtpass {
	
	my $cpass = &makepass ( $FORM{'ps'} );
	&prthtmlhead ( '�p�X���[�h' );
	print <<EOF;
<H2 align="center">�����͂�����Ղ� �p�X���[�h�ݒ���</H2>
<HR>
<FORM>
<CENTER>
<TABLE>
  <TR>
    <TD>
      <FONT size="+1">�Í����p�X���[�h�𐶐����܂����B</FONT><BR>
      �f���X�N���v�g�{�̂̏���̈ʒu�ɁA���L�̈Í����p�X���[�h��������R�s�[���Ă��������B
    </TD>
  </TR>
</TABLE>
<BR>
<TABLE border="2" cellspacing="4">
  <TR>
    <TD>�Ǘ��p�p�X���[�h</TD>
    <TD><INPUT type="text" name="dummy" value="$cpass" readonly></TD>
  </TR>
</TABLE>
</FORM>
</BODY>
</HTML>
EOF
}


###############################################################################
#  ���O�\��
###############################################################################

sub logprint {
	
	&loadmessage;
	print "Content-Type: text/plain\n\n";
	
	print @logdata;
}


###############################################################################
#  �Ǘ����j���[��ʕ\��
###############################################################################

sub adminmenu {
	
	&prthtmlhead ( '�����͂�����Ղ� �Ǘ����j���[' );
	print <<EOF;
<H2 align="center">�����͂�����Ղ� �Ǘ����j���[</H2>
<HR>
<CENTER>
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="ad" value="kl">
<INPUT type="hidden" name="u" value="$FORM{'u'}">
<INPUT type="submit" value="���b�Z�[�W�폜">
</FORM>
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="ad" value="rp">
<INPUT type="hidden" name="u" value="$FORM{'u'}">
<INPUT type="submit" value="�Í����p�X���[�h�Đ���">
</FORM>
<FORM method="post" action="$cgiurl">
<INPUT type="hidden" name="m" value="ad">
<INPUT type="hidden" name="ad" value="lv">
<INPUT type="hidden" name="u" value="$FORM{'u'}">
<INPUT type="submit" value="���O�{��">
</FORM>
<FORM method="post" action="$cgiurl">
<INPUT type="submit" value="�I��">
</FORM>
</CENTER>
</BODY>
</HTML>
EOF
}


###############################################################################
#  �Ǘ����[�h���C������
###############################################################################

sub adminmain {
	
	if ( !$FORM{'ad'} || $FORM{'ad'} eq 'tp' ) {
		&adminmenu;
	} elsif ( $FORM{'ad'} eq 'ps' ) {
		if ( $FORM{'ps'} ) {
			&prtpass;
		} else {
			&prterror ( '�p�X���[�h�����͂���Ă��܂���B' );
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
			&prterror ( '�F�؂Ɏ��s���܂����B' );
		}
	}
}


1;
