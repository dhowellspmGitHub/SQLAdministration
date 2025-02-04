CREATE TABLE [dbo].[CommercialGLQuoteExposureUnit] (
    [QuoteNbr]             VARCHAR (16)   NOT NULL,
    [UnitNbr]              INT            NOT NULL,
    [ProgramCd]            CHAR (1)       NULL,
    [CashUnitNbr]          CHAR (3)       NULL,
    [ClassRiskCd]          VARCHAR (22)   NULL,
    [ClassRiskDesc]        VARCHAR (255)  NULL,
    [ExposureLimitAmt]     DECIMAL (9)    NULL,
    [ExposureTypeCd]       VARCHAR (50)   NULL,
    [ExposurePremiumAmt]   DECIMAL (9, 2) NOT NULL,
    [ExposurePlusInd]      CHAR (1)       NULL,
    [LineItemAmt]          MONEY          NULL,
    [ExposureTaxAmt]       MONEY          NULL,
    [LiabilityIncludedInd] CHAR (1)       NULL,
    [CreatedTmstmp]        DATETIME       NOT NULL,
    [UserCreatedId]        CHAR (8)       NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]        CHAR (8)       NOT NULL,
    [LastActionCd]         CHAR (1)       NOT NULL,
    [SourceSystemCd]       CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialGLQuoteExposureUnit] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialGLQuoteExposureUnit_CommercialGLPolicyQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialGLQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialGLQuoteExposureUnit_01]
    ON [dbo].[CommercialGLQuoteExposureUnit]([QuoteNbr] ASC)
    ON [POLICYCI];

