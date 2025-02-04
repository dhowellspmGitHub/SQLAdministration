CREATE TABLE [dbo].[CommercialAutoUnitRatingInformation] (
    [PolicyId]              INT            NOT NULL,
    [UnitNbr]               INT            NOT NULL,
    [SequenceNbr]           CHAR (3)       NOT NULL,
    [PolicyNbr]             VARCHAR (16)   NOT NULL,
    [LineofBusinessCd]      CHAR (2)       NOT NULL,
    [SublineBusinessTypeCd] CHAR (1)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [RatingFieldNm]         VARCHAR (255)  NULL,
    [RatingValueTxt]        VARCHAR (100)  NULL,
    [RatingFctr]            DECIMAL (4, 3) NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialAutoUnitRatingInformation] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialAutoUnitRatingInformation_AutoUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[AutoUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];

