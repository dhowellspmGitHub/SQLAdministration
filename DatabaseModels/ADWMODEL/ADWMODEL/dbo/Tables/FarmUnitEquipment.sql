CREATE TABLE [dbo].[FarmUnitEquipment] (
    [PolicyId]                    INT            NOT NULL,
    [UnitNbr]                     INT            NOT NULL,
    [UnitTypeCd]                  CHAR (1)       NOT NULL,
    [LocationID]                  BIGINT         NULL,
    [PolicyNbr]                   VARCHAR (16)   NOT NULL,
    [SourceSystemDisplayUnitNbr]  INT            NULL,
    [CashUnitNbr]                 CHAR (3)       NULL,
    [ItemCoverageLimitAmt]        DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt] DECIMAL (9, 2) NULL,
    [ManufacturerNm]              VARCHAR (50)   NULL,
    [ManufacturingYearDt]         CHAR (4)       NULL,
    [ModelNm]                     VARCHAR (100)  NULL,
    [SerialNbr]                   CHAR (20)      NULL,
    [AdditionalInsuredPersonsNm]  VARCHAR (50)   NULL,
    [LivestockDesc]               VARCHAR (100)  NULL,
    [LivestockRegistrationNbr]    CHAR (20)      NULL,
    [UnitCnt]                     INT            NULL,
    [UnitAmt]                     DECIMAL (9, 2) NULL,
    [EquipmentUseDesc]            VARCHAR (255)  NULL,
    [EquipmentDesc]               VARCHAR (255)  NULL,
    [BulldozerOrBackhoeInd]       CHAR (1)       NULL,
    [LeaseInd]                    CHAR (1)       NULL,
    [EquipmentCategoryDesc]       VARCHAR (255)  NULL,
    [LiabilityInd]                CHAR (1)       NULL,
    [CreatedTmstmp]               DATETIME       NOT NULL,
    [UserCreatedId]               CHAR (8)       NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmUnitEquipment] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [UnitTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitEquipment_FarmUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr], [UnitTypeCd]) REFERENCES [dbo].[FarmUnit] ([PolicyId], [UnitNbr], [UnitTypeCd]),
    CONSTRAINT [FK_FarmUnitEquipment_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitEquipment_01]
    ON [dbo].[FarmUnitEquipment]([PolicyId] ASC)
    ON [POLICYCI];

