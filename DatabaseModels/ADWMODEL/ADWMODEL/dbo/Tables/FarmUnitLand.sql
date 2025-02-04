CREATE TABLE [dbo].[FarmUnitLand] (
    [PolicyId]                 INT            NOT NULL,
    [UnitNbr]                  INT            NOT NULL,
    [UnitTypeCd]               CHAR (1)       NOT NULL,
    [LocationID]               BIGINT         NULL,
    [PolicyNbr]                VARCHAR (16)   NOT NULL,
    [AcersCnt]                 DECIMAL (9, 2) NULL,
    [AdditionalDesc]           VARCHAR (255)  NULL,
    [OwnOrLeaseDesc]           VARCHAR (255)  NULL,
    [AdjoinedToDesc]           VARCHAR (255)  NULL,
    [LiabilityLimitAmt]        DECIMAL (9)    NULL,
    [MineSubsidenceCoverageCd] CHAR (1)       NULL,
    [CreatedTmstmp]            DATETIME       NOT NULL,
    [UserCreatedId]            CHAR (8)       NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]            CHAR (8)       NOT NULL,
    [LastActionCd]             CHAR (1)       NOT NULL,
    [SourceSystemCd]           CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmUnitLand] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [UnitTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitLand_FarmUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr], [UnitTypeCd]) REFERENCES [dbo].[FarmUnit] ([PolicyId], [UnitNbr], [UnitTypeCd]),
    CONSTRAINT [FK_FarmUnitLand_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitLand_01]
    ON [dbo].[FarmUnitLand]([PolicyId] ASC)
    ON [POLICYCI];

