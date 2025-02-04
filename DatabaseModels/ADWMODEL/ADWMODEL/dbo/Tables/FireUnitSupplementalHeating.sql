CREATE TABLE [dbo].[FireUnitSupplementalHeating] (
    [PolicyId]                   INT           NOT NULL,
    [UnitNbr]                    INT           NOT NULL,
    [ItemNbr]                    CHAR (3)      NOT NULL,
    [PolicyNbr]                  VARCHAR (16)  NOT NULL,
    [SupplementalHeatFuelTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitCnt]    INT           NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FireUnitSupplementalHeating] PRIMARY KEY CLUSTERED ([ItemNbr] ASC, [UnitNbr] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireUnitSupplementalHeating_FireUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[FireUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FireUnitSupplementalHeating_01]
    ON [dbo].[FireUnitSupplementalHeating]([PolicyId] ASC)
    ON [POLICYCI];

