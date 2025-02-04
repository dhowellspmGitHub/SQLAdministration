CREATE TABLE [dbo].[CommercialGLQuoteExposureUnitEndorsement] (
    [QuoteNbr]              VARCHAR (16)   NOT NULL,
    [EndorsementId]         INT            NOT NULL,
    [UnitNbr]               INT            NOT NULL,
    [EndorsementNbr]        CHAR (10)      NOT NULL,
    [EndorsementLimitAmt]   DECIMAL (9)    NULL,
    [EndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [PupilsCnt]             INT            NULL,
    [CreatedTmstmp]         DATETIME       NOT NULL,
    [UserCreatedId]         CHAR (8)       NOT NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialGLQuoteExposureUnitEndorsement] PRIMARY KEY CLUSTERED ([EndorsementId] ASC, [UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialGLQuoteExposureUnitEndorsement_CommercialGLQuoteExposureUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[CommercialGLQuoteExposureUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialGLQuoteExposureUnitEndorsement_01]
    ON [dbo].[CommercialGLQuoteExposureUnitEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];

