﻿CREATE TABLE [dbo].[AutoQuoteUnitEndorsement] (
    [QuoteNbr]                 VARCHAR (16)   NOT NULL,
    [QuoteUnitNbr]             INT            NOT NULL,
    [EndorsementNbr]           CHAR (10)      NOT NULL,
    [SublineBusinessTypeCd]    CHAR (1)       NOT NULL,
    [EndorsementDesc]          VARCHAR (100)  NULL,
    [EndorsementEditionYearDt] CHAR (4)       NULL,
    [EndorsementEffectiveDt]   DATE           NULL,
    [EndorsementLimitCd]       CHAR (3)       NULL,
    [EndorsementLimitAmt]      DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]    DECIMAL (9, 2) NULL,
    [EndorsementDeductibleCd]  CHAR (3)       NULL,
    [EndorsementMailFlagInd]   CHAR (1)       NULL,
    [MinimumPremInd]           BIT            NULL,
    [UpdatedTmstmp]            DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]            CHAR (8)       NOT NULL,
    [LastActionCd]             CHAR (1)       NOT NULL,
    [SourceSystemCd]           CHAR (2)       NOT NULL,
    CONSTRAINT [PK_AutoQuoteUnitEndorsement] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [QuoteUnitNbr] ASC, [EndorsementNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteUnitEndorsement_AutoQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [QuoteUnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoQuoteUnitEndorsement_01]
    ON [dbo].[AutoQuoteUnitEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];

