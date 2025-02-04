CREATE TABLE [dbo].[UmbrellaQuoteUnitDetail] (
    [QuoteNbr]            VARCHAR (16)  NOT NULL,
    [UnitNbr]             INT           NOT NULL,
    [SequenceNbr]         CHAR (3)      NOT NULL,
    [LocationID]          BIGINT        NULL,
    [OwnorLeaseCd]        CHAR (2)      NULL,
    [UnitNumberCnt]       INT           NULL,
    [UnitExcludedInd]     CHAR (1)      NULL,
    [ModelNm]             VARCHAR (100) NULL,
    [OwnOrLeaseDesc]      VARCHAR (255) NULL,
    [VehicleTypeCd]       VARCHAR (50)  NULL,
    [BoatLengthNbr]       DECIMAL (3)   NULL,
    [HorsePowerNbr]       DECIMAL (4)   NULL,
    [MaximumSpeedNbr]     INT           NULL,
    [ManufacturingYearDt] CHAR (4)      NULL,
    [MakeDesc]            VARCHAR (100) NULL,
    [ExternalPolicyNbr]   VARCHAR (16)  NULL,
    [VehicleTypeDesc]     VARCHAR (200) NULL,
    [AcresNbr]            INT           NULL,
    [VehicleUseCd]        VARCHAR (20)  NULL,
    [VehicleUseDesc]      VARCHAR (50)  NULL,
    [OperationRadiusDesc] VARCHAR (255) NULL,
    [CapacityCnt]         INT           NULL,
    [AdditionalDesc]      VARCHAR (255) NULL,
    [VehicleIDVINNbr]     CHAR (17)     NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [CreatedTmstmp]       DATETIME      NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [UserCreatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_UmbrellaQuoteUnitDetail] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [QuoteNbr] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaQuoteUnitDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID]),
    CONSTRAINT [FK_UmbrellaQuoteUnitDetail_UmbrellaQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[UmbrellaQuoteUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaQuoteUnitDetail_01]
    ON [dbo].[UmbrellaQuoteUnitDetail]([QuoteNbr] ASC)
    ON [POLICYCI];

