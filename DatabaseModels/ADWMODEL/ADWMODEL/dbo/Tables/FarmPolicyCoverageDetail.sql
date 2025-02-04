CREATE TABLE [dbo].[FarmPolicyCoverageDetail] (
    [PolicyId]               INT           NOT NULL,
    [CoverageCd]             CHAR (3)      NOT NULL,
    [NamedPersonsMedicalNbr] INT           NOT NULL,
    [PolicyNbr]              VARCHAR (16)  NOT NULL,
    [NamedPersonsMedicalNm]  VARCHAR (50)  NULL,
    [BirthDt]                DATE          NULL,
    [CreatedTmstmp]          DATETIME      NOT NULL,
    [UserCreatedId]          CHAR (8)      NOT NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmPolicyCoverageDetail] PRIMARY KEY CLUSTERED ([NamedPersonsMedicalNbr] ASC, [CoverageCd] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyCoverageDetail_FarmPolicyCoverage_01] FOREIGN KEY ([PolicyId], [CoverageCd]) REFERENCES [dbo].[FarmPolicyCoverage] ([PolicyId], [CoverageCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicyCoverageDetail_01]
    ON [dbo].[FarmPolicyCoverageDetail]([PolicyId] ASC)
    ON [POLICYCI];

