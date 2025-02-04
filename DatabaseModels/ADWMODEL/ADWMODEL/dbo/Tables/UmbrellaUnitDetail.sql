CREATE TABLE [dbo].[UmbrellaUnitDetail] (
    [UmbrellaUnitDetailsId] INT           NOT NULL,
    [SequenceNbr]           CHAR (3)      NOT NULL,
    [UnitNbr]               INT           NOT NULL,
    [PolicyId]              INT           NOT NULL,
    [LocationID]            BIGINT        NULL,
    [VehicleIDVINNbr]       CHAR (17)     NOT NULL,
    [VehicleUseCd]          VARCHAR (20)  NULL,
    [VehicleUseDesc]        VARCHAR (50)  NULL,
    [PolicyNbr]             VARCHAR (16)  NOT NULL,
    [OwnorLeaseCd]          CHAR (2)      NULL,
    [UnitNumberCnt]         INT           NULL,
    [UnitExcludedInd]       CHAR (1)      NULL,
    [ModelNm]               VARCHAR (100) NULL,
    [OwnOrLeaseDesc]        VARCHAR (255) NULL,
    [VehicleTypeCd]         VARCHAR (50)  NULL,
    [BoatLengthNbr]         DECIMAL (3)   NULL,
    [HorsePowerNbr]         DECIMAL (4)   NULL,
    [MaximumSpeedNbr]       INT           NULL,
    [ManufacturingYearDt]   CHAR (4)      NULL,
    [MakeDesc]              VARCHAR (100) NULL,
    [ExternalPolicyNbr]     VARCHAR (16)  NULL,
    [VehicleTypeDesc]       VARCHAR (200) NULL,
    [AcresNbr]              INT           NULL,
    [MiscellaneousDesc]     VARCHAR (300) NULL,
    [UpdatedTmstmp]         DATETIME2 (7) NOT NULL,
    [CreatedTmstmp]         DATETIME      NOT NULL,
    [UserUpdatedId]         CHAR (8)      NOT NULL,
    [UserCreatedId]         CHAR (8)      NOT NULL,
    [LastActionCd]          CHAR (1)      NOT NULL,
    [SourceSystemCd]        CHAR (2)      NOT NULL,
    [OperationRadiusDesc]   VARCHAR (255) NULL,
    [CapacityCnt]           INT           NULL,
    [AdditionalDesc]        VARCHAR (255) NULL,
    CONSTRAINT [PK_UmbrellaUnitVehicleDetail] PRIMARY KEY CLUSTERED ([UmbrellaUnitDetailsId] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaUnitDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID]),
    CONSTRAINT [FK_UmbrellaUnitDetail_UmbrellaUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[UmbrellaUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaUnitDetail_01]
    ON [dbo].[UmbrellaUnitDetail]([PolicyId] ASC)
    ON [POLICYCI];

