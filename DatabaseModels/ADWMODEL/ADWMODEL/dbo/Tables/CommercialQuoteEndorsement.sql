CREATE TABLE [dbo].[CommercialQuoteEndorsement] (
    [QuoteNbr]                          VARCHAR (16)   NOT NULL,
    [EndorsementId]                     INT            NOT NULL,
    [EndorsementNbr]                    CHAR (10)      NOT NULL,
    [EndorsementLimitCd]                CHAR (3)       NULL,
    [EndorsementLimitAmt]               DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]             DECIMAL (9, 2) NULL,
    [EndorsementDeductibleAmt]          DECIMAL (9)    NULL,
    [CompanyOrClientNm]                 VARCHAR (255)  NULL,
    [IncreasedLimitAmt]                 DECIMAL (9)    NULL,
    [UpdatedTmstmp]                     DATETIME2 (7)  NOT NULL,
    [BusinessIncomeExtraExpenseDaysNbr] INT            NULL,
    [UserUpdatedId]                     CHAR (8)       NOT NULL,
    [LastActionCd]                      CHAR (1)       NOT NULL,
    [SourceSystemCd]                    CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialQuoteEndorsement] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialQuoteEndorsement_CommercialQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialQuote] ([QuoteNbr]),
    CONSTRAINT [FK_CommercialQuoteEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialQuoteEndorsement_01]
    ON [dbo].[CommercialQuoteEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];

