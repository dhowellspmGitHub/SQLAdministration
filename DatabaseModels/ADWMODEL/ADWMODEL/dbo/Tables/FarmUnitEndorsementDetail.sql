CREATE TABLE [dbo].[FarmUnitEndorsementDetail] (
    [PolicyId]                    INT            NOT NULL,
    [UnitNbr]                     INT            NOT NULL,
    [UnitTypeCd]                  CHAR (1)       NOT NULL,
    [EndorsementNbr]              CHAR (10)      NOT NULL,
    [ItemNbr]                     CHAR (3)       NOT NULL,
    [ArticleNbr]                  CHAR (3)       NOT NULL,
    [LocationID]                  BIGINT         NULL,
    [EndorsementId]               INT            NULL,
    [PolicyNbr]                   VARCHAR (16)   NOT NULL,
    [SourceSystemDisplayUnitNbr]  INT            NULL,
    [CashUnitNbr]                 CHAR (3)       NULL,
    [ItemCoverageLimitAmt]        DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt] DECIMAL (9, 2) NULL,
    [ItemBasicDesc]               VARCHAR (250)  NULL,
    [ItemFreeFormDesc]            TEXT           NULL,
    [ManufacturerNm]              VARCHAR (50)   NULL,
    [ManufacturingYearDt]         CHAR (4)       NULL,
    [ModelNm]                     VARCHAR (100)  NULL,
    [SerialNbr]                   CHAR (20)      NULL,
    [InturruptCnt]                INT            NULL,
    [IncreaseForItemDesc]         CHAR (150)     NULL,
    [LivestockUnitCnt]            INT            NULL,
    [LivestockWeightNbr]          INT            NULL,
    [LivestockTotalValueAmt]      DECIMAL (9)    NULL,
    [LivestockBackupDesc]         VARCHAR (100)  NULL,
    [SignalTypeDesc]              VARCHAR (255)  NULL,
    [MembershipNbr]               CHAR (10)      NULL,
    [PlantCnt]                    INT            NULL,
    [TrayCnt]                     INT            NULL,
    [OutBuildingDesc]             VARCHAR (250)  NULL,
    [DaysNbr]                     INT            NULL,
    [MonthNm]                     CHAR (10)      NULL,
    [DayCnt]                      INT            NULL,
    [TotalPlantsCnt]              INT            NULL,
    [CreatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserCreatedId]               CHAR (8)       NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmUnitEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementNbr] ASC, [PolicyId] ASC, [UnitNbr] ASC, [UnitTypeCd] ASC, [ItemNbr] ASC, [ArticleNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitEndorsementDetail_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_FarmUnitEndorsementDetail_FarmUnitEndorsement_01] FOREIGN KEY ([PolicyId], [UnitNbr], [EndorsementNbr], [UnitTypeCd]) REFERENCES [dbo].[FarmUnitEndorsement] ([PolicyId], [UnitNbr], [EndorsementNbr], [UnitTypeCd]),
    CONSTRAINT [FK_FarmUnitEndorsementDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD] TEXTIMAGE_ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitEndorsementDetail_01]
    ON [dbo].[FarmUnitEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];

