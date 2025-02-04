CREATE TABLE [dbo].[PropertyAddressPolicyBridge] (
    [PropertyAddressId] INT           NOT NULL,
    [PolicyId]          INT           NOT NULL,
    [PolicyNbr]         VARCHAR (16)  NOT NULL,
    [LineofBusinessCd]  CHAR (2)      NOT NULL,
    [ActiveAddressInd]  BIT           NOT NULL,
    [CreatedTmstmp]     DATETIME2 (7) NOT NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PropertyAddressPolicyBridge] PRIMARY KEY CLUSTERED ([PropertyAddressId] ASC, [PolicyId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_PropertyAddressPolicyBridge_Policy_02] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId]),
    CONSTRAINT [FK_PropertyAddressPolicyBridge_PropertyAddress_01] FOREIGN KEY ([PropertyAddressId]) REFERENCES [dbo].[PropertyAddress] ([PropertyAddressId])
) ON [CLAIMSCD];

