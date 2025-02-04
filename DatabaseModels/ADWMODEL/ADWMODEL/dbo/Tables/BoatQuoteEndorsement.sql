CREATE TABLE [dbo].[BoatQuoteEndorsement] (
    [EndorsementId]                  INT            NOT NULL,
    [QuoteNbr]                       VARCHAR (16)   NOT NULL,
    [EndorsementNbr]                 CHAR (10)      NOT NULL,
    [EndorsementLimitAmt]            DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]          DECIMAL (9, 2) NULL,
    [UnscheduledPersonalPropertyInd] CHAR (1)       NULL,
    [UpdatedTmstmp]                  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                  CHAR (8)       NOT NULL,
    [LastActionCd]                   CHAR (1)       NOT NULL,
    [SourceSystemCd]                 CHAR (2)       NOT NULL,
    CONSTRAINT [PK_BoatQuoteEndorsement] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatQuoteEndorsement_BoatQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[BoatQuote] ([QuoteNbr]),
    CONSTRAINT [FK_BoatQuoteEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId])
) ON [POLICYCD];

