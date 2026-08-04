# Modular Sales Processing Engine (ABAP)

An enterprise-inspired architectural breakdown of a retail sales processing engine built inside SAP ERP. This project demonstrates modular programming decoupling, functional signature interfaces, and transactional logic pipelines using **Function Groups (FG)** and **Function Modules (FM)** within the ABAP runtime environment.

---

## 🏗️ Core Application Architecture Topology

The application orchestrates its processing context across three distinct operational layers. This design ensures that the user interface, mathematical operations, and global tracking buffers remain loosely coupled.

```text
               +-----------------------------------+

               |      SELECTION SCREEN INPUTS      |
               | (p_itm_nm, p_itm_qn, p_itm_pr)    |
               +-----------------+-----------------+
                                 |
                                 v
               +-----------------+-----------------+

               |   ORCHESTRATION LAYER (Report)    |
               |    "ZAS_SALES_ENG_PROCESSING"     |
               +-----------------+-----------------+
                                 |
        +────────────────────────┼────────────────────────+
        │                        │                        │
        ▼                        ▼                        ▼
+-------+-------+        +-------+-------+        +-------+-------+

|  FUNCTION 1   |        |  FUNCTION 2   |        |  FUNCTION 3   |
| ZFM_CAL_TOTAL_│        | ZFM_CAL_PRICE |        | ZFM_CAL_DISC  |
|     SELL      |        |               |        |               |
+-------+-------+        +-------+-------+        +-------+-------+
        │                        │                        │
        └────────────────────────┼────────────────────────┘
                                 │
                                 ▼
               +-----------------+-----------------+

               |  FUNCTION 4: GENERATE_INVOICE_NO  |
               +-----------------+-----------------+
                                 |
                                 v
               +-----------------+-----------------+

               |     SHARED STATE ENGINE LAYER     |
               |   Function Group Global Memory    |
               |   (ZFG_ASS_TESTINGS_2 Repository) |
               +-----------------------------------+
```

---

## 🔀 Data Flow & Parameter Interface Sequence Graph

The graph below traces the parameter exchange pipeline when the orchestration report triggers execution via **Execute (F8)**.

```text
[Click F8 Run]
      │
      ├──► (Step 1) Call ZFM_CAL_TOTAL_SELL
      │               ├───► [Input]:  IM_ITEM_NAME (String), IM_ITEM_QNTY (I)
      │               └───◄ [Output]: EX_TOTAL (I) -> Accumulated total quantity
      │
      ├──► (Step 2) Call ZFM_CAL_PRICE
      │               ├───► [Input]:  IM_PRICE (I) -> Price per unit
      │               └───◄ [Output]: EX_TOTAL_BILL (NETWR_AK) -> Raw Subtotal
      │
      ├──► (Step 3) Call ZFM_CAL_DISC
      │               ├───► [Input]:  IM_SUBTOTAL (I) -> Base calculated price
      │               └───◄ [Output]: EX_DISC_BILL (NETWR_AK) -> Final customer bill
      │
      └──► (Step 4) Call ZFM_GENERATE_INVOICE_NO
                      ├───► [Input]:  None
                      └───◄ [Output]: EX_INVOICE_NO (I) -> Unique serialization ID
                              │
                              ▼
                   [Output Invoice Screen]
```

---

## 🌳 Bulk Purchase Rebate Decision Tree

The conditional evaluation tree mapped inside `ZFM_CAL_DISC` dynamically processes the subtotal to isolate wholesale logic transactions.

```text
                 [ Evaluate Total Item Volume ]
                                │
                                │  Is accumulated count
                                │  greater than 100 units?
                                │
                ┌───────────────┴───────────────┐
                │                               │
             ┌──▼──┐                         ┌──▼──┐
             │ YES │                         │ NO  │
             └──┬──┘                         └──┬──┘
                │                               │
                ▼                               ▼
    [ Apply Matrix Rebate ]          [ Maintain Standard Price ]
       Import IM_SUBTOTAL               Import IM_SUBTOTAL
     Calculate 10% Deduction          No Deductions Applied
                │                               │
                └───────────────┬───────────────┘
                                │
                                ▼
                  [ Trigger Memory Cleanup ]
                  Reset active transactional tracking
                                │
                                ▼
                    [ Export EX_DISC_BILL ]
```

---

## 📂 Git Repository Blueprint File Tree

To organize your GitHub portfolio project cleanly, map your physical source files to this repository directory hierarchy:

```text
├── README.md                              <-- Project Architectures & Interface Signatures
└── src/                                   <-- Source Root
    ├── zas_sales_eng_processing.abap      <-- UI & Orchestration Report
    └── zfg_ass_testings_2.fugr/           <-- Encapsulated Function Group Container
        ├── lzfg_ass_testings_2top.abap   <-- Shared Global State Variables Include
        ├── zfm_cal_total_sell.abap        <-- Quantity Accumulator Module (FM1)
        ├── zfm_cal_price.abap             <-- Item Valuation Multiplier (FM2)
        ├── zfm_cal_disc.abap              <-- Conditional Rebate Core (FM3)
        └── zfm_generate_invoice_no.abap   <-- Serialization Number Worker (FM4)
```
