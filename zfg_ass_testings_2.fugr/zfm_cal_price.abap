FUNCTION ZFM_CAL_PRICE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_PRICE) TYPE  I
*"  EXPORTING
*"     REFERENCE(EX_TOTAL_BILL) TYPE  NETWR_AK
*"----------------------------------------------------------------------

ex_total_bill = im_price * gv_total_items.

*clear gv_total_items.


ENDFUNCTION.