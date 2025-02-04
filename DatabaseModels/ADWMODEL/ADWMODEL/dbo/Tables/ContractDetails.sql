CREATE TABLE [dbo].[ContractDetails] (
    [ContractNbr]         VARCHAR (50)   NOT NULL,
    [CompanyNm]           VARCHAR (80)   NOT NULL,
    [ContractDesc]        VARCHAR (255)  NOT NULL,
    [EffectiveDt]         DATE           NOT NULL,
    [ExpirationDt]        DATE           NOT NULL,
    [BrokerReferenceDesc] CHAR (50)      NULL,
    [BrokerReferenceNbr]  CHAR (30)      NOT NULL,
    [CoverholderNm]       VARCHAR (255)  NOT NULL,
    [CoverholderPINNbr]   VARCHAR (50)   NOT NULL,
    [BusinessCodeDesc]    VARCHAR (25)   NOT NULL,
    [TotalCommissionPct]  DECIMAL (5, 2) NOT NULL,
    [VendorCommissionPct] DECIMAL (5, 2) NOT NULL,
    [ActiveInd]           BIT            NOT NULL,
    [UserUpdatedId]       CHAR (8)       NOT NULL,
    [UpdatedTmstmp]       DATETIME2 (7)  NOT NULL,
    [UserCreatedId]       CHAR (8)       NOT NULL,
    [CreatedTmstmp]       DATETIME       NOT NULL,
    [SourceSystemCd]      CHAR (2)       NOT NULL,
    [LastActionCd]        CHAR (1)       NOT NULL,
    CONSTRAINT [PK_ContractDetails] PRIMARY KEY NONCLUSTERED ([ContractNbr] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

