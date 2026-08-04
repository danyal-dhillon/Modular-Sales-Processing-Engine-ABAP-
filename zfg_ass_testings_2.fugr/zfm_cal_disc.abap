FUNCTION zfm_cal_disc.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_SUBTOTAL) TYPE  I
*"  EXPORTING
*"     REFERENCE(EX_DISC_BILL) TYPE  NETWR_AK
*"----------------------------------------------------------------------

gv_total_items = im_subtotal.

  IF gv_total_items > 1000000.
    ex_disc_bill = im_subtotal * '0.90'.
  ELSEIF gv_total_items > 100000.
    ex_disc_bill = im_subtotal * '0.95'.
  ELSEIF gv_total_items > 50000.
    ex_disc_bill = im_subtotal * '0.98'.
  ELSE.
    ex_disc_bill = im_subtotal.
  ENDIF.

clear gv_total_items.

ENDFUNCTION.