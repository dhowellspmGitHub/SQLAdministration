CREATE TABLE [dbo].[CommercialGLEndorsementDetail] (
    [PolicyId]                        INT            NOT NULL,
    [CommercialGLEndorsementDetailId] INT            NOT NULL,
    [EndorsementNbr]                  CHAR (10)      NOT NULL,
    [EndorsementId]                   INT            NOT NULL,
    [LocationID]                      BIGINT         NULL,
    [PolicyAdditionalInsuredId]       BIGINT         NOT NULL,
    [PolicyNbr]                       VARCHAR (16)   NOT NULL,
    [ItemNbr]                         CHAR (3)       NOT NULL,
    [ItemBasicDesc]                   VARCHAR (250)  NULL,
    [EndorsementLimitAmt]             DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]           DECIMAL (9, 2) NULL,
    [HazzardDesc]                     VARCHAR (255)  NULL,
    [IncludedExcludedCountryNm]       VARCHAR (255)  NULL,
    [LocationDesc]                    VARCHAR (255)  NULL,
    [EquipmentSerialNbr]              CHAR (20)      NULL,
    [ManufacturerNm]                  VARCHAR (50)   NULL,
    [ModelNm]                         VARCHAR (100)  NULL,
    [ManufacturingYearDt]             CHAR (4)       NULL,
    [PurchaseYearDt]                  CHAR (4)       NULL,
    [EndorsementPremiumManualAmt]     DECIMAL (9, 2) NULL,
    [PersonOrOrganizationNm]          VARCHAR (512)  NULL,
    [CreatedTmstmp]                   DATETIME       NOT NULL,
    [UserCreatedId]                   CHAR (8)       NOT NULL,
    [UpdatedTmstmp]                   DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                   CHAR (8)       NOT NULL,
    [LastActionCd]                    CHAR (1)       NOT NULL,
    [SourceSystemCd]                  CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialGLEndorsementDetail] PRIMARY KEY CLUSTERED ([CommercialGLEndorsementDetailId] ASC, [EndorsementId] ASC, [PolicyId] ASC, [EndorsementNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialGLEndorsementDetail_CommercialGLEndorsement_01] FOREIGN KEY ([PolicyId], [EndorsementId], [EndorsementNbr]) REFERENCES [dbo].[CommercialGLEndorsement] ([PolicyId], [EndorsementId], [EndorsementNbr]),
    CONSTRAINT [FK_CommercialGLEndorsementDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID]),
    CONSTRAINT [FK_CommercialGLEndorsementDetail_PolicyAdditionalInsured_01] FOREIGN KEY ([PolicyAdditionalInsuredId]) REFERENCES [dbo].[PolicyAdditionalInsured] ([PolicyAdditionalInsuredId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialGLEndorsementDetail_01]
    ON [dbo].[CommercialGLEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];

