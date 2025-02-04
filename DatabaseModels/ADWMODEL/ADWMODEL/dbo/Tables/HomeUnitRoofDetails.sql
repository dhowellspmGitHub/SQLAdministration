CREATE TABLE [dbo].[HomeUnitRoofDetails] (
    [PolicyId]               INT           NOT NULL,
    [UnitNbr]                INT           NOT NULL,
    [RoofNbr]                INT           NOT NULL,
    [PolicyNbr]              VARCHAR (16)  NOT NULL,
    [RoofDesc]               VARCHAR (255) NULL,
    [RoofPitchCd]            CHAR (2)      NULL,
    [RoofShapeCd]            CHAR (2)      NULL,
    [RoofTypeCd]             CHAR (2)      NULL,
    [RoofConstructionYearDt] CHAR (4)      NULL,
    [RoofReplacedYearDt]     CHAR (4)      NULL,
    [ExposureToTreesCd]      CHAR (2)      NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    CONSTRAINT [PK_HomeUnitRoofDetails] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [RoofNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeUnitRoofDetails_HomeUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[HomeUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];

