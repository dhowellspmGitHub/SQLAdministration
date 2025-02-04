CREATE TABLE [dbo].[UmbrellaPolicyEndorsementDetail] (
    [EndorsementDetailId] INT           NOT NULL,
    [PolicyId]            INT           NOT NULL,
    [EndorsementId]       INT           NOT NULL,
    [PolicyNbr]           VARCHAR (16)  NOT NULL,
    [EndorsementNbr]      CHAR (10)     NOT NULL,
    [ItemNbr]             CHAR (3)      NOT NULL,
    [ArticleNbr]          CHAR (3)      NOT NULL,
    [LastTransactionDt]   DATE          NULL,
    [ItemBasicDesc]       VARCHAR (250) NULL,
    [ItemFreeFormDesc]    TEXT          NULL,
    [LocationNameDesc]    VARCHAR (255) NULL,
    [ManufacturingYearDt] CHAR (4)      NULL,
    [MakeDesc]            VARCHAR (100) NULL,
    [ModelNm]             VARCHAR (100) NULL,
    [AddressDesc]         VARCHAR (100) NULL,
    [TrustMemberNm]       VARCHAR (255) NULL,
    [VehicleHullIDVINNbr] CHAR (17)     NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_UmbrellaPolicyEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaPolicyEndorsementDetail_UmbrellaPolicyEndorsement_01] FOREIGN KEY ([PolicyId], [EndorsementId]) REFERENCES [dbo].[UmbrellaPolicyEndorsement] ([PolicyId], [EndorsementId])
) ON [POLICYCD] TEXTIMAGE_ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaPolicyEndorsementDetail_01]
    ON [dbo].[UmbrellaPolicyEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];

