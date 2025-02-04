CREATE TABLE [dbo].[PolicyCoverageCodes] (
    [LineofBusinessCd]       CHAR (2)      NULL,
    [CoverageCd]             CHAR (3)      NULL,
    [CoverageLimitAmt]       DECIMAL (9)   NULL,
    [SourceSystemCoverageCd] VARCHAR (100) NULL,
    [CoverageLimitCd]        CHAR (3)      NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [PolicyCoverageCodesId]  INT           IDENTITY (1, 1) NOT NULL,
    [CoverageTypeCd]         CHAR (1)      NULL,
    [CreatedTmstmp]          DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_PolicyCoverageCodes] PRIMARY KEY CLUSTERED ([PolicyCoverageCodesId] ASC) ON [POLICYCD]
) ON [POLICYCD];

