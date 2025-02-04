CREATE TABLE [dbo].[CommercialGLQuoteEndorsement] (
    [QuoteNbr]                    VARCHAR (16)   NOT NULL,
    [EndorsementId]               INT            NOT NULL,
    [EndorsementNbr]              CHAR (10)      NOT NULL,
    [LocationID]                  BIGINT         NULL,
    [EndorsementLimitCd]          CHAR (3)       NULL,
    [EndorsementLimitAmt]         DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]       DECIMAL (9, 2) NULL,
    [EndorsementDeductibleAmt]    DECIMAL (9)    NULL,
    [EndorsementPremiumManualAmt] DECIMAL (9, 2) NULL,
    [BodiesProcessedCnt]          INT            NULL,
    [PupilsCnt]                   INT            NULL,
    [CoverageEffectiveDt]         DATE           NULL,
    [CompanyOrClientNm]           VARCHAR (255)  NULL,
    [ClassDesc]                   VARCHAR (255)  NULL,
    [DayCnt]                      INT            NULL,
    [AdditionalLimitAmt]          DECIMAL (9)    NULL,
    [BasisLimitAmt]               DECIMAL (9)    NULL,
    [TransitLimitAmt]             DECIMAL (9)    NULL,
    [TempPropertyLimitAmt]        DECIMAL (9)    NULL,
    [CoverageExpirationDt]        DATE           NULL,
    [PremisesDesc]                VARCHAR (255)  NULL,
    [CreatedTmstmp]               DATETIME       NOT NULL,
    [UserCreatedId]               CHAR (8)       NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialGLQuoteEndorsement] PRIMARY KEY CLUSTERED ([EndorsementNbr] ASC, [QuoteNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialGLQuoteEndorsement_CommercialGLPolicyQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialGLQuote] ([QuoteNbr]),
    CONSTRAINT [FK_CommercialGLQuoteEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_CommercialGLQuoteEndorsement_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialGLQuoteEndorsement_01]
    ON [dbo].[CommercialGLQuoteEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];

