CREATE TABLE [dbo].[CommercialBuildingUnitSupplementalHeating] (
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
    CONSTRAINT [PK_CommercialBuildingUnitSupplementalHeating] PRIMARY KEY CLUSTERED ([ItemNbr] ASC, [PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingUnitSupplementalHeating_CommercialBuildingUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[CommercialBuildingUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];

