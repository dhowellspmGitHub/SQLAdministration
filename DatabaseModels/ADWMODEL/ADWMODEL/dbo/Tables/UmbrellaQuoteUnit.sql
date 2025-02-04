CREATE TABLE [dbo].[UmbrellaQuoteUnit] (
    [QuoteNbr]                      VARCHAR (16)  NOT NULL,
    [UnitNbr]                       INT           NOT NULL,
    [TotalAcresCnt]                 INT           NULL,
    [EffectiveDt]                   DATE          NULL,
    [ExpirationDt]                  DATE          NULL,
    [ExternalPolicyInd]             CHAR (1)      NULL,
    [InsuranceCompanyNm]            VARCHAR (80)  NULL,
    [PolicyTypeCd]                  CHAR (1)      NULL,
    [ExternalPolicyNbr]             VARCHAR (16)  NULL,
    [NonOwnedAutoCoverageInd]       CHAR (1)      NULL,
    [AllStatesLiabilityInd]         CHAR (1)      NULL,
    [JonesFELAAdmiraltyExposureInd] CHAR (1)      NULL,
    [TeachersLiabilityInd]          CHAR (1)      NULL,
    [UpdatedTmstmp]                 DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                 CHAR (8)      NOT NULL,
    [LastActionCd]                  CHAR (1)      NOT NULL,
    [SourceSystemCd]                CHAR (2)      NOT NULL,
    CONSTRAINT [PK_UmbrellaQuoteUnit] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [QuoteNbr] ASC),
    CONSTRAINT [FK_UmbrellaQuoteUnit_UmbrellaQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[UmbrellaQuote] ([QuoteNbr])
);


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaQuoteUnit_01]
    ON [dbo].[UmbrellaQuoteUnit]([QuoteNbr] ASC)
    ON [POLICYCI];

