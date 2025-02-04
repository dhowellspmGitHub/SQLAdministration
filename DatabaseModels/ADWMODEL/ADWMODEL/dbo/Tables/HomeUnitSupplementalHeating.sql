CREATE TABLE [dbo].[HomeUnitSupplementalHeating] (
    [UnitNbr]                    INT           NOT NULL,
    [PolicyId]                   INT           NOT NULL,
    [ItemNbr]                    CHAR (3)      NOT NULL,
    [PolicyNbr]                  VARCHAR (16)  NOT NULL,
    [SupplementalHeatFuelTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitCnt]    INT           NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_HomeUnitSupplementalHeating] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [ItemNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeUnitSupplementalHeating_HomeUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[HomeUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];

