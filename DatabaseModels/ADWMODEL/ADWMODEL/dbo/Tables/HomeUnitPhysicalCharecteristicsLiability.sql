CREATE TABLE [dbo].[HomeUnitPhysicalCharecteristicsLiability] (
    [PolicyId]                INT           NOT NULL,
    [UnitNbr]                 INT           NOT NULL,
    [PhysicalCharLiabilityCd] CHAR (10)     NOT NULL,
    [PolicyNbr]               VARCHAR (16)  NOT NULL,
    [DebitCreditPointsNbr]    INT           NULL,
    [PhysicalCharCategoryCd]  CHAR (10)     NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_HomeUnitPhysicalCharecteristicsLiability] PRIMARY KEY NONCLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [PhysicalCharLiabilityCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeUnitPhysicalCharecteristicsLiability_HomeUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[HomeUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];

