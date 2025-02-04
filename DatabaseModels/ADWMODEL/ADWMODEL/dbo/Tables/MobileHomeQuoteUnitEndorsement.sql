CREATE TABLE [dbo].[MobileHomeQuoteUnitEndorsement] (
    [EndorsementId]                  INT            NOT NULL,
    [QuoteNbr]                       VARCHAR (16)   NOT NULL,
    [UnitNbr]                        INT            NOT NULL,
    [EndorsementNbr]                 CHAR (10)      NOT NULL,
    [EndorsementLimitAmt]            DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]          DECIMAL (9, 2) NULL,
    [AppliedDeductiblePercentageInd] CHAR (1)       NULL,
    [OverCoachAnchoringInd]          CHAR (1)       NULL,
    [EarthQuakeDeductiblePct]        DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]                  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                  CHAR (8)       NOT NULL,
    [LastActionCd]                   CHAR (1)       NOT NULL,
    [SourceSystemCd]                 CHAR (2)       NOT NULL,
    CONSTRAINT [PK_MobileHomeQuoteUnitEndorsement] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [UnitNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeQuoteUnitEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_MobileHomeQuoteUnitEndorsement_MobileHomeQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[MobileHomeQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

