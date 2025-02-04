CREATE TABLE [dbo].[CommercialBuildingQuoteUnitClassification] (
    [QuoteNbr]             VARCHAR (16)   NOT NULL,
    [UnitNbr]              INT            NOT NULL,
    [ClassificationNbr]    INT            NOT NULL,
    [ClassCd]              CHAR (5)       NOT NULL,
    [ClassificationDesc]   VARCHAR (255)  NULL,
    [ExposureAmt]          INT            NULL,
    [ExposurePremiumAmt]   DECIMAL (9, 2) NOT NULL,
    [PropertyTypeDesc]     VARCHAR (50)   NULL,
    [ExposureTypeCd]       VARCHAR (50)   NOT NULL,
    [AreaNbr]              INT            NULL,
    [OperationDesc]        VARCHAR (255)  NULL,
    [PrimaryOccupationInd] CHAR (1)       NULL,
    [ClassCodeSequenceNbr] CHAR (5)       NULL,
    [CreatedTmstmp]        DATETIME       NOT NULL,
    [UserCreatedId]        CHAR (8)       NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]        CHAR (8)       NOT NULL,
    [LastActionCd]         CHAR (1)       NOT NULL,
    [SourceSystemCd]       CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialBuildingQuoteUnitClassification] PRIMARY KEY CLUSTERED ([ClassificationNbr] ASC, [UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingQuoteUnitClassification_CommercialBuildingQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[CommercialBuildingQuoteUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingQuoteUnitClassification_01]
    ON [dbo].[CommercialBuildingQuoteUnitClassification]([QuoteNbr] ASC)
    ON [POLICYCI];

