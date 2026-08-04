FUNCTION ZFM_CAL_TOTAL_SELL.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_ITEM_NAME) TYPE  STRING
*"     REFERENCE(IM_ITEM_QNTY) TYPE  I
*"     REFERENCE(IM_ITEM_UNIT) TYPE  STRING
*"  EXPORTING
*"     REFERENCE(EX_TOTAL) TYPE  I
*"----------------------------------------------------------------------

gv_total_items = gv_total_items + im_item_qnty.

ex_total = im_item_qnty.

*gv_total_items = ex_total.



ENDFUNCTION.