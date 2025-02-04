CREATE TABLE [dbo].[CommercialIMQuoteEndorsement] (
    [QuoteNbr]                 VARCHAR (16)   NOT NULL,
    [EndorsementId]            INT            NOT NULL,
    [EndorsementNbr]           CHAR (10)      NOT NULL,
    [LocationID]               BIGINT         NULL,
    [EndorsementLimitCd]       CHAR (3)       NULL,
    [EndorsementLimitAmt]      DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]    DECIMAL (9, 2) NULL,
    [EndorsementDeductibleAmt] DECIMAL (9)    NULL,
    [CreatedTmstmp]            DATETIME       NOT NULL,
    [UserCreatedId]            CHAR (8)       NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]            CHAR (8)       NOT NULL,
    [LastActionCd]             CHAR (1)       NOT NULL,
    [SourceSystemCd]           CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialIMQuoteEndorsement] PRIMARY KEY CLUSTERED ([EndorsementNbr] ASC, [QuoteNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIMQuoteEndorsement_CommercialQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialQuote] ([QuoteNbr]),
    CONSTRAINT [FK_CommercialIMQuoteEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_CommercialIMQuoteEndorsement_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIMQuoteEndorsement_01]
    ON [dbo].[CommercialIMQuoteEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];

