CREATE TABLE [dbo].[PaymentTransactionDetails] (
    [PaymentTransactionDetailsId] INT            NOT NULL,
    [PaymentDetailsId]            INT            NOT NULL,
    [EntityTypeCd]                CHAR (1)       NOT NULL,
    [EntityNbr]                   VARCHAR (16)   NOT NULL,
    [LineofBusinessCd]            CHAR (2)       NULL,
    [PaymentAmt]                  DECIMAL (9, 2) NOT NULL,
    [AgencyNbr]                   CHAR (3)       NULL,
    [MembershipCountyNbr]         CHAR (3)       NULL,
    [MembershipPaidYearDt]        CHAR (4)       NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    CONSTRAINT [PK_PaymentTransactionDetails] PRIMARY KEY CLUSTERED ([PaymentTransactionDetailsId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_PaymentTransactionDetails_PaymentDetails_01] FOREIGN KEY ([PaymentDetailsId]) REFERENCES [dbo].[PaymentDetails] ([PaymentDetailsId])
) ON [CLAIMSCD];

