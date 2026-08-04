*&---------------------------------------------------------------------*
*& Report ZAS_SALES_ENG_PROCESSING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zas_sales_eng_processing.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_cust TYPE string OBLIGATORY.
  PARAMETERS: p_itm_nm TYPE string OBLIGATORY.
  PARAMETERS: p_itm_qt TYPE i OBLIGATORY.
  PARAMETERS: p_itm_ut TYPE string OBLIGATORY.
  PARAMETERS: p_itm_pr TYPE i OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  DATA: lv_cust_name TYPE string,
        lv_item_unit TYPE string.
  lv_cust_name = p_cust.
  lv_item_unit = p_itm_ut.

* FM 1: Counting the Items

*DATA IM_ITEM_NAME TYPE STRING.
*DATA IM_ITEM_QNTY TYPE I.
*DATA EX_TOTAL     TYPE I.
  DATA: lv_total TYPE i.
  CALL FUNCTION 'ZFM_CAL_TOTAL_SELL'
    EXPORTING
      im_item_name = p_itm_nm
      im_item_qnty = p_itm_qt
      im_item_unit = lv_item_unit
    IMPORTING
      ex_total     = lv_total.

* FM 2: Calculating the Price of Sold Items

*DATA IM_PRICE      TYPE I.
*DATA EX_TOTAL_BILL TYPE NETWR_AK.
  DATA: lv_total_bill TYPE netwr_ak.
  CALL FUNCTION 'ZFM_CAL_PRICE'
    EXPORTING
      im_price      = p_itm_pr
    IMPORTING
      ex_total_bill = lv_total_bill.


* FM 3: Calculating the Discount

*DATA IM_SUBTOTAL  TYPE I.
*DATA EX_DISC_BILL TYPE NETWR_AK.
  DATA: lv_subtotal  TYPE i,
        lv_disc_bill TYPE netwr_ak.
  lv_subtotal = lv_total_bill.

  CALL FUNCTION 'ZFM_CAL_DISC'
    EXPORTING
      im_subtotal  = lv_subtotal
    IMPORTING
      ex_disc_bill = lv_disc_bill.


* FM 4: Generating the Unique Invoice Number

*DATA EX_INVOICE_NO TYPE STRING.
  DATA: lv_invoice_no TYPE string.

  CALL FUNCTION 'ZFM_GENERATE_INVOICE_NO'
    IMPORTING
      ex_invoice_no = lv_invoice_no.





  WRITE: / '========================================='.
  WRITE: / '        SALES PROCESSING RESULTS         '.
  WRITE: / '========================================='.

  WRITE: / '========================================='.
  WRITE: / '        INVOICE NUMBER:', lv_invoice_no .
  WRITE: / '========================================='.
  WRITE: / |Customer Name      : { lv_cust_name }|.
  WRITE: / |Item Name          : { p_itm_nm }|.
  WRITE: / |Item Quantity      : { p_itm_qt } { lv_item_unit }|.
  WRITE: / |Price Per { lv_item_unit }       : PKR { p_itm_pr }/-|.
  WRITE: / |Total Price        : PKR { lv_total_bill }/-|.
  WRITE: / |Total Price to Pay : PKR { lv_disc_bill }/-|.
  WRITE: / '========================================='.