CREATE TABLE [dbo].[FarmUnitDwellingRoofDetail] (
    [PolicyId]                   INT           NOT NULL,
    [UnitNbr]                    INT           NOT NULL,
    [UnitTypeCd]                 CHAR (1)      NOT NULL,
    [PolicyNbr]                  VARCHAR (16)  NOT NULL,
    [SourceSystemDisplayUnitNbr] INT           NULL,
    [CashUnitNbr]                CHAR (3)      NULL,
    [RoofPitchCd]                CHAR (2)      NULL,
    [RoofShapeCd]                CHAR (2)      NULL,
    [RoofTypeCd]                 CHAR (2)      NULL,
    [RoofConstructionYearDt]     CHAR (4)      NULL,
    [RoofYearVerifiedInd]        CHAR (1)      NULL,
    [ExposureToTreesCd]          CHAR (2)      NULL,
    [CreatedTmstmp]              DATETIME      NOT NULL,
    [UserCreatedId]              CHAR (8)      NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmUnitDwellingRoofDetail] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [UnitTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitDwellingRoofDetail_FarmUnitDwelling_01] FOREIGN KEY ([PolicyId], [UnitNbr], [UnitTypeCd]) REFERENCES [dbo].[FarmUnitDwelling] ([PolicyId], [UnitNbr], [UnitTypeCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitDwellingRoofDetail_01]
    ON [dbo].[FarmUnitDwellingRoofDetail]([PolicyId] ASC)
    ON [POLICYCI];

