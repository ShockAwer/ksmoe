#! /usr/local/bin/perl

#
#	�����͂�����Ղ� Rev.0.1 Preview 9 (2000.9.3)
#	 (�l�p���ݒ��ʗp�֐��Q)
#


###############################################################################
#  ���ݒ��ʕ\��
###############################################################################

sub prtcustom {
	
	my ( @follow, @reload );
	$follow[$followwin] = 'checked';
	$reload[$reltype] = 'checked';
	
	&prthtmlhead ( "$bbstitle �l�p���ݒ�" );
	print <<EOF;
<H3>$bbstitle �l�p���ݒ�</H3><BR>
<FORM method="post" action="$cgiurl">
  <INPUT type="hidden" name="m" value="c">
  <INPUT type="hidden" name="nm" value="$FORM{'m'}">
  <UL>
    <LI><STRONG>�\\���ݒ�</STRONG><BR> <BR>
    <TABLE border="0" cellspacing="0" cellpadding="0">
      <TR>
        <TD>�����F�@�@�@</TD>
        <TD><INPUT type="text" name="tc" size="7" value="$CC{'text'}"></TD>
        <TD>�@�w�i�F</TD>
        <TD><INPUT type="text" name="bc" size="7" value="$CC{'bg'}"></TD>
      </TR>
      <TR>
        <TD>�����N�F</TD>
        <TD><INPUT type="text" name="lc" size="7" value="$CC{'link'}"></TD>
        <TD>�@�K��σ����N�F </TD>
        <TD><INPUT type="text" name="vc" size="7" value="$CC{'vlink'}"></TD>
      </TR>
      <TR>
        <TD>���p�F</TD>
        <TD><INPUT type="text" name="qc" size="7" value="$CC{'qmsgc'}"></TD>
        <TD>�@</TD>
        <TD>�@</TD>
      </TR>
    </TABLE>
  </UL>
  <UL>
    <LI><STRONG>�t���@�\\�ݒ�</STRONG><BR> <BR>
    gzip���k�]�� <INPUT type="checkbox" name="g" value="checked" $S_gzchk[$gzipu]><BR>
    URL���������N <INPUT type="checkbox" name="a" value="checked" $S_alchk[$autolink]><BR>
  </UL>
  <UL>
    <LI><STRONG>�t�H���[��ʂ̕\\�����@</STRONG><BR> <BR>
    <INPUT type="radio" name="fw" value="0" $follow[0]>�V�K�E�B���h�E���J���ĕ\\��<BR>
    <INPUT type="radio" name="fw" value="1" $follow[1]>�V�K�E�B���h�E���J�����ɕ\\��<BR>
  </UL>
  <UL>
    <LI><STRONG>�O�������[�h���̃��b�Z�[�W�̕\\�����@</STRONG><BR> <BR>
    <INPUT type="radio" name="rt" value="0" $reload[0]>�W���i���e�����~���\\���j<BR>
    <INPUT type="radio" name="rt" value="1" $reload[1]>���]�i���e���������\\���j<BR>
  </UL>
  <BR>
  �u�o�^�v����������ɕ\\�������URL���u�b�N�}�[�N�ɓo�^���܂��傤�B<BR>
  ��L�̐ݒ�Ōf����K�₷�邱�Ƃ��ł��܂��B<BR> <BR>
  <INPUT type="submit" value="�o�^">
  <INPUT type="reset" value="���ɖ߂�">
  <INPUT type="submit" name="cr" value="�K��l�ɖ߂�">
  <INPUT type="submit" name="cdc" value="Cookie����">
</FORM>
</BODY>
</HTML>
EOF
}


###############################################################################
#  ���ݒ茋�ʉ�ʕ\��
###############################################################################

sub setcustom {
	
	my ( $p1, $p2, $p3, $nm, %alchk, %gzchk );
	
	if ( !$FORM{'cr'} ) {
		$alchk{'checked'} = 1;
		$gzchk{'checked'} = 1;
		$p1 = sprintf ( "%x", $alchk{"$FORM{'a'}"} + $FORM{'fw'} * 2 + $FORM{'rt'} * 4 + $gzchk{"$FORM{'g'}"} * 8 );
		$p2 = 0;
		$p3 = 0;
		if ( $FORM{'nm'} eq 'op' ) {
			$nm = 'm=o&';
		} else {
			$nm = '';
		}
		$FORM{'c'} = "$FORM{'tc'}$FORM{'bc'}$FORM{'lc'}$FORM{'vc'}$FORM{'qc'}$p1$p2$p3";
	} else {
		$FORM{'c'} = '';
	}
	
	if ( $FORM{'cdc'} ) {
		&putcookie ( $S_cexp - 2 );
	} else {
		&putcookie ( 0 ) if ( $cookie );
	}
	print "Location: $cgiurl?${nm}c=$FORM{'c'}\n\n";
}


1;


__END__
