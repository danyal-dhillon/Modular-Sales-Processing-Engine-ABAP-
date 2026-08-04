FUNCTION ZFM_GENERATE_INVOICE_NO.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_INVOICE_NO) TYPE  STRING
*"----------------------------------------------------------------------

gv_invoice_no = gv_invoice_no + 1.

ex_invoice_no = |Cust_{ gv_invoice_no WIDTH = 5 ALIGN = RIGHT PAD = '0' }|.

ENDFUNCTION.