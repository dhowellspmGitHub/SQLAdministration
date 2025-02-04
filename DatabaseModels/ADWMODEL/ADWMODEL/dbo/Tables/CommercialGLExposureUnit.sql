CREATE TABLE [dbo].[CommercialGLExposureUnit] (
    [PolicyId]                 INT            NOT NULL,
    [UnitNbr]                  INT            NOT NULL,
    [PolicyNbr]                VARCHAR (16)   NOT NULL,
    [ProgramCd]                CHAR (1)       NULL,
    [CashUnitNbr]              CHAR (3)       NULL,
    [ClassRiskCd]              VARCHAR (22)   NULL,
    [ClassRiskDesc]            VARCHAR (255)  NULL,
    [ExposureLimitAmt]         DECIMAL (9)    NULL,
    [ExposureTypeCd]           VARCHAR (50)   NULL,
    [ExposurePremiumAmt]       DECIMAL (9, 2) NOT NULL,
    [ExposurePlusInd]          CHAR (1)       NULL,
    [LineItemAmt]              MONEY          NULL,
    [ExposureTaxAmt]           MONEY          NULL,
    [LiabilityIncludedInd]     CHAR (1)       NULL,
    [AllinesItemNbr]           CHAR (3)       NULL,
    [RateClassCd]              CHAR (1)       NULL,
    [ConstructionTypeCd]       CHAR (1)       NULL,
    [ConstructionYearDt]       CHAR (4)       NULL,
    [SurchargeExemptStatusCd]  CHAR (1)       NULL,
    [ProtectionClassCd]        CHAR (2)       NULL,
    [ProductsCompletedInd]     CHAR (1)       NULL,
    [MinimumPremiumInd]        CHAR (1)       NULL,
    [CoInsurancePercentCd]     CHAR (1)       NULL,
    [AllinesLocationCountyNbr] CHAR (3)       NULL,
    [TerritoryCd]              CHAR (1)       NULL,
    [OccupancyTypeCd]          CHAR (1)       NULL,
    [ItemMiscellaneousDesc]    VARCHAR (250)  NULL,
    [CreatedTmstmp]            DATETIME       NOT NULL,
    [UserCreatedId]            CHAR (8)       NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]            CHAR (8)       NOT NULL,
    [LastActionCd]             CHAR (1)       NOT NULL,
    [SourceSystemCd]           CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialGLExposureUnit] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialGLExposureUnit_CommercialGLPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[CommercialGLPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialGLExposureUnit_01]
    ON [dbo].[CommercialGLExposureUnit]([PolicyId] ASC)
    ON [POLICYCI];

