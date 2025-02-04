CREATE TABLE [dbo].[QuotePremium] (
    [QuoteNbr]                    VARCHAR (16)   NOT NULL,
    [LineofBusinessCd]            CHAR (2)       NOT NULL,
    [SublineBusinessTypeCd]       CHAR (1)       NOT NULL,
    [BasicPolicyPremiumAmt]       DECIMAL (9, 2) NULL,
    [BasicPolicyGrossPremiumAmt]  DECIMAL (9, 2) NULL,
    [AdditionalPremiumAmt]        DECIMAL (9, 2) NULL,
    [EndorsementPolicyPremiumAmt] DECIMAL (9, 2) NULL,
    [TotalPremiumAmt]             DECIMAL (9, 2) NULL,
    [TotalTaxAmt]                 DECIMAL (9, 2) NULL,
    [TotalDiscountAmt]            DECIMAL (9, 2) NULL,
    [EQTotalPremiumAmt]           DECIMAL (9, 2) NULL,
    [EQTotalTaxAmt]               DECIMAL (9, 2) NULL,
    [EQEndorsementPremiumAmt]     DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_QuotePremium] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_QuotePremium_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];

