#! /usr/local/bin/perl

#
#	�����͂�����Ղ� Rev.0.1 Preview 9 (2000.9.3)
#	 (�g�s�b�N�ꗗ�\��)
#

my ( @TID, %TCOUNT, %TTITLE, %TTIME );

###############################################################################
#  �g�s�b�N�ꗗ�擾
###############################################################################

sub gettopic {
	
	my ( @olglog );
	
	if ( $FORM{'e'} =~ /^[\w.]+$/ ) {

		$FORM{'e'} =~ /.*\.(.*)/;
		if ( $1 =~ /htm/ || !$oldlogfmt ) {
			
			# HTML�`��
			# (HTML�`���̏ꍇ�A�X���b�hID�̎擾���ł��Ȃ��̂ŁA�{�X�N���v�g�ł�
			#  �T�|�[�g����܂���)
			&prterror ( 'HTML�`���̉ߋ����O�ɂ͑Ή����Ă��܂���' );
			
		} else {
			
			# �o�C�i���`��
			open ( OLDLOG, "$oldlogfiledir$FORM{'e'}" ) || &prterror ( "$FORM{'e'}���J���܂���ł���" );
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
		&prterror ( '�t�@�C�������s���ł�' );
	}
}


###############################################################################
#  �g�s�b�N�ꗗ�\��
###############################################################################

sub lsttopic {
	
	my ( $tc, $tt );
	
	&gettopic;
	
	$FORM{'e'} =~ /(\d\d\d\d)(\d\d)(\d\d)\.(\w)/;
	&prthtmlhead ( "$bbstitle �g�s�b�N�ꗗ $1/$2/$3" );
	
	print <<EOF;
<P><STRONG><FONT size="+1">$bbstitle �g�s�b�N�ꗗ</FONT></STRONG></P>
<FONT size="-1">�\\�� - ���� - ���e - �ŏI�X�V����</FONT>
<HR>
<FONT size="-1">
EOF
	
	for ( $i = 0 ; $i < @TID ; $i++ ) {
		$tc = sprintf ( "%02d", $TCOUNT{$TID[$i]} );
		$tt = &getnowdate ( $TTIME{$TID[$i]} );
		print <<EOF;
<A href="$cgiurl?m=t&ff=$FORM{'e'}&s=$TID[$i]&c=$FORM{'c'}">��</A> $tc $TTITLE{$TID[$i]} ($tt)<BR>
EOF
	}
	
	print <<EOF;
</FONT>
<HR>
<P align="right"><A href="$cgiurl">�f����</A></P>
</BODY>
</HTML>
EOF
	exit;
}

1;
