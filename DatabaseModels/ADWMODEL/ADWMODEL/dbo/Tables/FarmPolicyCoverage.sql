CREATE TABLE [dbo].[FarmPolicyCoverage] (
    [PolicyId]                 INT            NOT NULL,
    [CoverageCd]               CHAR (3)       NOT NULL,
    [PolicyNbr]                VARCHAR (16)   NOT NULL,
    [CoverageDesc]             VARCHAR (250)  NOT NULL,
    [CoverageLimitCd]          CHAR (3)       NULL,
    [CoverageLimitCodeDesc]    VARCHAR (20)   NULL,
    [CoverageLimitAmt]         DECIMAL (9)    NULL,
    [CoveragePremiumAmt]       DECIMAL (9, 2) NULL,
    [CoverageDeductibleTypeCd] CHAR (3)       NULL,
    [SourceSystemCoverageCd]   VARCHAR (100)  NULL,
    [ManWorkDaysNbr]           INT            NULL,
    [NamedMedicalPersonsCnt]   INT            NULL,
    [UpdatedTmstmp]            DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]            CHAR (8)       NOT NULL,
    [LastActionCd]             CHAR (1)       NOT NULL,
    [SourceSystemCd]           CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmPolicyCoverage] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [CoverageCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyCoverage_FarmPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FarmPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicyCoverage_01]
    ON [dbo].[FarmPolicyCoverage]([PolicyId] ASC)
    ON [POLICYCI];

