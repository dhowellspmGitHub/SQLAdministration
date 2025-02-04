CREATE TABLE [dbo].[GarageAddress] (
    [GarageAddressId]       INT           NOT NULL,
    [PolicyId]              INT           NOT NULL,
    [UnitNbr]               INT           NOT NULL,
    [PolicyNbr]             VARCHAR (16)  NOT NULL,
    [SublineBusinessTypeCd] CHAR (1)      NOT NULL,
    [StreetAddressDesc]     VARCHAR (100) NULL,
    [CityNm]                CHAR (30)     NULL,
    [CountyNbr]             CHAR (3)      NULL,
    [StateCd]               CHAR (2)      NULL,
    [ZipCd]                 CHAR (9)      NULL,
    [LocationDescTxt]       VARCHAR (100) NULL,
    [UpdatedTmstmp]         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]         CHAR (8)      NOT NULL,
    [LastActionCd]          CHAR (1)      NOT NULL,
    [SourceSystemCd]        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_GarageAddress] PRIMARY KEY CLUSTERED ([GarageAddressId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_GarageAddress_AutoUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[AutoUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_GarageAddress_01]
    ON [dbo].[GarageAddress]([PolicyId] ASC, [UnitNbr] ASC)
    ON [POLICYCI];

