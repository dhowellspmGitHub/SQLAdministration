CREATE TABLE [dbo].[CommercialIM] (
    [PolicyId]                 INT             NOT NULL,
    [IMPartCoverageTypeCd]     VARCHAR (50)    NOT NULL,
    [PolicyNbr]                VARCHAR (16)    NOT NULL,
    [PartTypeDesc]             VARCHAR (200)   NULL,
    [MiscellaneousItemDesc]    VARCHAR (255)   NULL,
    [CoveragePropertyDesc]     VARCHAR (255)   NULL,
    [RiskTypeCd]               CHAR (10)       NULL,
    [RefigerationBreakdownInd] CHAR (1)        NULL,
    [UnattendedTheftInd]       CHAR (1)        NULL,
    [DeductibleAmt]            DECIMAL (18, 2) NULL,
    [StainGlassExcessInd]      CHAR (1)        NULL,
    [TotalCoverageLimitAmt]    DECIMAL (9)     NULL,
    [LimitAmt]                 DECIMAL (9)     NULL,
    [IMUnitNbr]                INT             NULL,
    [CreatedTmstmp]            DATETIME        NOT NULL,
    [UserCreatedId]            CHAR (8)        NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]            CHAR (8)        NOT NULL,
    [LastActionCd]             CHAR (1)        NOT NULL,
    [SourceSystemCd]           CHAR (2)        NOT NULL,
    CONSTRAINT [PK_CommercialIM] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [IMPartCoverageTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIM_CommercialPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[CommercialPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIM_01]
    ON [dbo].[CommercialIM]([PolicyId] ASC)
    ON [POLICYCI];

