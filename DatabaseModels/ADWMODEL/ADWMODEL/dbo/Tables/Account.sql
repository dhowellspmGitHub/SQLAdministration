CREATE TABLE [dbo].[Account] (
    [AccountBillNbr]        CHAR (10)      NOT NULL,
    [AccountNm]             VARCHAR (100)  NULL,
    [DueDt]                 DATE           NULL,
    [DueAmt]                DECIMAL (9, 2) NULL,
    [InetPayInd]            CHAR (1)       NULL,
    [UnprocessedPaymentInd] CHAR (1)       NULL,
    [MembershipNbr]         CHAR (10)      NULL,
    [BranchNbr]             CHAR (3)       NOT NULL,
    [AgencyNbr]             CHAR (3)       NULL,
    [AccountCommencedDt]    DATE           NULL,
    [AccountCeasedDt]       DATE           NULL,
    [AccountOriginTypeCd]   VARCHAR (10)   NULL,
    [AccountStatusCd]       VARCHAR (10)   NULL,
    [AccountTypeCd]         VARCHAR (10)   NULL,
    [BankAccountNbr]        VARCHAR (20)   NULL,
    [BankABANbr]            VARCHAR (20)   NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED ([AccountBillNbr] ASC) ON [POLICYCD]
) ON [POLICYCD];

