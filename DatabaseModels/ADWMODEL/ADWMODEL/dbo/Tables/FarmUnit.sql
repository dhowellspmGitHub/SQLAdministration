CREATE TABLE [dbo].[FarmUnit] (
    [PolicyId]                   INT           NOT NULL,
    [UnitNbr]                    INT           NOT NULL,
    [UnitTypeCd]                 CHAR (1)      NOT NULL,
    [LocationID]                 BIGINT        NULL,
    [PolicyNbr]                  VARCHAR (16)  NOT NULL,
    [FarmDewellingsNbr]          INT           NULL,
    [SourceSystemDisplayUnitNbr] INT           NULL,
    [CashUnitNbr]                CHAR (3)      NULL,
    [CountyNbr]                  CHAR (3)      NULL,
    [MilesFromTownNbr]           INT           NULL,
    [FarmDirectionCd]            CHAR (2)      NULL,
    [FarmOLTTownRoadNm]          VARCHAR (60)  NULL,
    [FarmOwnerCd]                CHAR (1)      NULL,
    [LegalAddressDesc]           VARCHAR (300) NULL,
    [UnitAddedDt]                DATE          NULL,
    [UnitInceptionDt]            DATE          NULL,
    [TerritoryCd]                CHAR (1)      NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmUnit] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [UnitTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnit_FarmPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FarmPolicy] ([PolicyId]),
    CONSTRAINT [FK_FarmUnit_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnit_01]
    ON [dbo].[FarmUnit]([PolicyId] ASC)
    ON [POLICYCI];

