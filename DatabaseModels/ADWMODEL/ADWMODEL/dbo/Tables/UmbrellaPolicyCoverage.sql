CREATE TABLE [dbo].[UmbrellaPolicyCoverage] (
    [PolicyId]              INT            NOT NULL,
    [CoverageCd]            CHAR (3)       NOT NULL,
    [PolicyNbr]             VARCHAR (16)   NOT NULL,
    [CoverageDeductibleAmt] DECIMAL (5)    NULL,
    [CoverageDeductibleCd]  CHAR (3)       NULL,
    [CoverageDesc]          VARCHAR (250)  NULL,
    [CoverageLimitAmt]      DECIMAL (9)    NULL,
    [CoverageLimitCd]       CHAR (3)       NULL,
    [CoverageLimitCodeDesc] VARCHAR (20)   NULL,
    [CoveragePremiumAmt]    DECIMAL (9, 2) NULL,
    [CreatedTmstmp]         DATETIME       NOT NULL,
    [UserCreatedId]         CHAR (8)       NOT NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_UmbrellaPolicyCoverage] PRIMARY KEY CLUSTERED ([CoverageCd] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaPolicyCoverage_UmbrellaPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[UmbrellaPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaPolicyCoverage_01]
    ON [dbo].[UmbrellaPolicyCoverage]([PolicyId] ASC)
    ON [POLICYCI];

