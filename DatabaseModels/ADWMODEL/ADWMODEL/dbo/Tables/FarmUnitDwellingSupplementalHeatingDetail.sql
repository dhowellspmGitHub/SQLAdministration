CREATE TABLE [dbo].[FarmUnitDwellingSupplementalHeatingDetail] (
    [PolicyId]                   INT           NOT NULL,
    [UnitNbr]                    INT           NOT NULL,
    [UnitTypeCd]                 CHAR (1)      NOT NULL,
    [ItemNbr]                    CHAR (3)      NOT NULL,
    [PolicyNbr]                  VARCHAR (16)  NOT NULL,
    [SourceSystemDisplayUnitNbr] INT           NULL,
    [CashUnitNbr]                CHAR (3)      NULL,
    [SupplementalHeatFuelTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitCnt]    INT           NULL,
    [CreatedTmstmp]              DATETIME      NOT NULL,
    [UserCreatedId]              CHAR (8)      NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmUnitDwellingSupplementalHeatingDetail] PRIMARY KEY CLUSTERED ([ItemNbr] ASC, [PolicyId] ASC, [UnitNbr] ASC, [UnitTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitDwellingSupplementalHeatingDetail_FarmUnitDwelling_01_1] FOREIGN KEY ([PolicyId], [UnitNbr], [UnitTypeCd]) REFERENCES [dbo].[FarmUnitDwelling] ([PolicyId], [UnitNbr], [UnitTypeCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitDwellingSupplementalHeatingDetail_01]
    ON [dbo].[FarmUnitDwellingSupplementalHeatingDetail]([PolicyId] ASC)
    ON [POLICYCI];

